output "kubeadm_join_token" {
  value     = local.kubeadm_token
  sensitive = true
}

# output "workers" {
#   value     = module.worker_node
#   sensitive = true
# }

# output "controllers" {
#   value     = module.controller_node
#   sensitive = true
# }

# output "nodes" {
#   value = [
#     for node in append(
#       [for node in module.controller_node : node.details]) : {
#       name     = subscription.subscription_name,
#       id       = subscription.subscription_id,
#       env      = subscription.environment,
#       ip_range = subscription.ip_range,
#     }
#   ]
# }
