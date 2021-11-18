module "controller_nodes" {
  source   = "./modules/controller_node"
  for_each = toset(range(0, var.num_controllers))

  node_num                     = for_each.value
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
