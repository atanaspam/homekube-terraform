output "kubeadm_join_token" {
  value     = local.kubeadm_token
  sensitive = true
}

output "workers" {
  value     = module.worker_nodes
}

output "controllers" {
  value     = module.controller_nodes
}

output "nodes" {
  value = concat(
    [for node in module.worker_nodes : node],
    [for node in module.controller_nodes : node],
  )
}
