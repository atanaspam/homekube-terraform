# output "ipaddress" {
#   value = vsphere_virtual_machine.testvm.guest_ip_addresses
# }

# output "template" {
#     value = data.template_file.kube_controller_0_userdata.rendered
# }

output "kubeadm_join_token" {
  value     = local.kubeadm_token
  sensitive = true
}
