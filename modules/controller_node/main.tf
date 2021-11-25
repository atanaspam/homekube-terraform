locals {
  kubernetes_ca                 = fileexists("${path.root}/ca/kubernetes-ca/kubernetes-ca.pem") ? file("${path.root}/ca/kubernetes-ca/kubernetes-ca.pem") : ""
  kubernetes_ca_key             = fileexists("${path.root}/ca/kubernetes-ca/kubernetes-ca-key.pem") ? file("${path.root}/ca/kubernetes-ca/kubernetes-ca-key.pem") : ""
  kubernetes_front_proxy_ca     = fileexists("${path.root}/ca/kubernetes-front-proxy-ca/kubernetes-front-proxy-ca.pem") ? file("${path.root}/ca/kubernetes-front-proxy-ca/kubernetes-front-proxy-ca.pem") : ""
  kubernetes_front_proxy_ca_key = fileexists("${path.root}/ca/kubernetes-front-proxy-ca/kubernetes-front-proxy-ca-key.pem") ? file("${path.root}/ca/kubernetes-front-proxy-ca/kubernetes-front-proxy-ca-key.pem") : ""
  etcd_ca                       = fileexists("${path.root}/ca/etcd-ca/etcd-ca.pem") ? file("${path.root}/ca/etcd-ca/etcd-ca.pem") : ""
  etcd_ca_key                   = fileexists("${path.root}/ca/etcd-ca/etcd-ca-key.pem") ? file("${path.root}/ca/etcd-ca/etcd-ca-key.pem") : ""
  hostname                      = "kube-controller-${var.node_num}"
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter_name
}

data "vsphere_datastore" "vmstore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "vmnetwork" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "templatevm" {
  name          = "ubuntu-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "template_file" "kube_controller_metadata" {
  template = file("${path.root}/cloudinit/metadata.yaml")
  vars = {
    hostname = local.hostname
    instance_id = "i-${md5(local.hostname)}"
  }
}

data "template_file" "kube_controller_userdata" {
  template = file("${path.root}/cloudinit/userdata-controller.yaml")
  vars = {
    token                         = var.kubeadm_join_token
    byoca                         = var.bring_your_own_ca
    kubernetes_ca                 = indent(6, local.kubernetes_ca)
    kubernetes_ca_key             = indent(6, local.kubernetes_ca_key)
    kubernetes_front_proxy_ca     = indent(6, local.kubernetes_front_proxy_ca)
    kubernetes_front_proxy_ca_key = indent(6, local.kubernetes_front_proxy_ca_key)
    etcd_ca                       = indent(6, local.etcd_ca)
    etcd_ca_key                   = indent(6, local.etcd_ca_key)
  }
}

resource "vsphere_virtual_machine" "kube_controller" {
  name             = "Kubernetes Controller ${var.node_num}"
  datastore_id     = data.vsphere_datastore.vmstore.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  num_cpus         = 2
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.templatevm.guest_id
  scsi_type        = data.vsphere_virtual_machine.templatevm.scsi_type
  enable_disk_uuid = true # https://askubuntu.com/a/1249890

  network_interface {
    network_id     = data.vsphere_network.vmnetwork.id
    adapter_type   = data.vsphere_virtual_machine.templatevm.network_interface_types[0]
    use_static_mac = "true"
    mac_address    = var.mac_address # Maps to the MAC specified in the PfSense DHCP Server
  }
  wait_for_guest_net_timeout = 3

  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.templatevm.disks.0.size
    # eagerly_scrub    = data.vsphere_virtual_machine.templatevm.disks.0.eagerly_scrub
    # thin_provisioned = data.vsphere_virtual_machine.templatevm.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.templatevm.id
  }

  extra_config = {
    "guestinfo.metadata"          = base64encode(data.template_file.kube_controller_metadata.rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.kube_controller_userdata.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }
}

resource "null_resource" "first_controller_wait" {
  # Only wait for the first controller to be ready
  count = var.node_num == 0 ? 1 : 0

  triggers {
    node_num = "${var.node_num}"
  }

  connection {
      host     = self.default_ip_address
      type     = "ssh"
      user     = var.vm_ssh_username
      password = var.vm_ssh_password
    }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
    ]
  }
}
