output "hostname" {
  value = local.hostname
}

output "ip_address" {
  value = vsphere_virtual_machine.kube_worker.default_ip_address
}

output "role" {
  value = "worker"
}
