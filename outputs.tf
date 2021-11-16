output "kubeadm_join_token" {
  value     = local.kubeadm_token
  sensitive = true
}
