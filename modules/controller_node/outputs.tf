output "hostname" {
  value = local.hostname
}

output "ip_address" {
  value = vsphere_virtual_machine.kube_controller.default_ip_address
}

output "role" {
  value = "controller"
}
