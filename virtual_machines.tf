data "vsphere_datacenter" "dc" {
  name = ""
}

data "vsphere_datastore" "vmstore" {
  name          = "VM DataStore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Main Cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "vmnetwork" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "templatevm" {
  name          = "ubuntu-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "template_file" "kube_controller_0_metadata" {
  template = file("${path.module}/cloudinit/metadata.yaml")
  vars = {
    ip       = "10.1.4.0" # Already specified in the PfSense DHCP server
    hostname = "kube-controller-0"
  }
}

data "template_file" "kube_controller_0_userdata" {
  template = file("${path.module}/cloudinit/userdata-controller.yaml")
  vars = {
    token                         = local.kubeadm_token
    byoca                         = var.bring_your_own_ca
    kubernetes_ca                 = indent(6, local.kubernetes_ca)
    kubernetes_ca_key             = indent(6, local.kubernetes_ca_key)
    kubernetes_front_proxy_ca     = indent(6, local.kubernetes_front_proxy_ca)
    kubernetes_front_proxy_ca_key = indent(6, local.kubernetes_front_proxy_ca_key)
    etcd_ca                       = indent(6, local.etcd_ca)
    etcd_ca_key                   = indent(6, local.etcd_ca_key)
  }
}

resource "vsphere_virtual_machine" "kube_controller_0" {
  name             = "Kubernetes Controller 0"
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
    mac_address    = "00:50:56:80:f3:20" # Maps to the MAC specified in the PfSense DHCP Server
  }
  wait_for_guest_net_timeout = 0

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
    "guestinfo.metadata"          = base64encode(data.template_file.kube_controller_0_metadata.rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.kube_controller_0_userdata.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
    ]
    connection {
      host     = "10.1.4.0"
      type     = "ssh"
      user     = var.ssh_username
      password = var.ssh_password
    }
  }
}

data "template_file" "kube_worker_0_metadata" {
  template = file("${path.module}/cloudinit/metadata.yaml")
  vars = {
    ip       = "10.1.4.100" # Already specified in the PfSense DHCP server
    hostname = "kube-worker-0"
  }
}

data "template_file" "kube_worker_0_userdata" {
  template = file("${path.module}/cloudinit/userdata-worker.yaml")
  vars = {
    token                         = local.kubeadm_token
    byoca                         = var.bring_your_own_ca
    kubernetes_ca                 = indent(6, local.kubernetes_ca)
    kubernetes_ca_key             = indent(6, local.kubernetes_ca_key)
    kubernetes_front_proxy_ca     = indent(6, local.kubernetes_front_proxy_ca)
    kubernetes_front_proxy_ca_key = indent(6, local.kubernetes_front_proxy_ca_key)
    etcd_ca                       = indent(6, local.etcd_ca)
    etcd_ca_key                   = indent(6, local.etcd_ca_key)
    discovery_token_ca_cert_hash  = var.discovery_token_ca_cert_hash
  }
}


resource "vsphere_virtual_machine" "kube_worker_0" {
  name             = "Kubernetes Worker 0"
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
    mac_address    = "00:50:56:80:f3:2d" # Maps to the MAC specified in the PfSense DHCP Server
  }
  wait_for_guest_net_timeout = 0

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
    "guestinfo.metadata"          = base64encode(data.template_file.kube_worker_0_metadata.rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.kube_worker_0_userdata.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }

  depends_on = [
    vsphere_virtual_machine.kube_controller_0
  ]
}
