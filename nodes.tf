module "controller_nodes" {
  source = "./modules/controller_node"
  count  = var.num_controllers

  node_num                     = count.index
  datacenter_name              = var.datacenter_name
  datastore_name               = var.datastore_name
  cluster_name                 = var.cluster_name
  network_name                 = var.network_name
  vm_ssh_username              = var.vm_ssh_username
  vm_ssh_password              = var.vm_ssh_password
  bring_your_own_ca            = var.bring_your_own_ca
  discovery_token_ca_cert_hash = var.discovery_token_ca_cert_hash
  kubeadm_join_token           = local.kubeadm_token
}

module "worker_nodes" {
  source = "./modules/worker_node"
  count  = var.num_workers

  node_num                     = count.index
  datacenter_name              = var.datacenter_name
  datastore_name               = var.datastore_name
  cluster_name                 = var.cluster_name
  network_name                 = var.network_name
  vm_ssh_username              = var.vm_ssh_username
  vm_ssh_password              = var.vm_ssh_password
  bring_your_own_ca            = var.bring_your_own_ca
  discovery_token_ca_cert_hash = var.discovery_token_ca_cert_hash
  kubeadm_join_token           = local.kubeadm_token
  depends_on = [
    module.controller_nodes
  ]
}
