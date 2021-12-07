variable "vcenter_server" {
  type        = string
  description = "The URL to the vCenter Server."
}

variable "vcenter_username" {
  type        = string
  description = "The username for authenticating to the vCenter server."
}

variable "vcenter_password" {
  type        = string
  description = "The password for authenticating to the vCenter server."
}

variable "datastore_name" {
  type        = string
  description = "The name of the vSphere datastore that will be used for the kubernetes VMs."
}

variable "datacenter_name" {
  type        = string
  description = "The name of the vSphere datacenter where kubernetes VMs will be deployed."
}

variable "network_name" {
  type        = string
  description = "The name of the vSphere network that will be used by the kubernetes VMs."
}

variable "vm_name" {
  type        = string
  description = "The name of the VM used by packer."
}

variable "vm_ssh_username" {
  type = string
  description = "The username to use for SSH access to the created VM."
}

variable "vm_ssh_password" {
  type      = string
  sensitive = true
  description = "The password to use for SSH access to the created VM."
}

variable "vm_ssh_password_hash" {
  type      = string
  sensitive = true
  description = "The hash of the SSH password to be used the user-data file. Use openssl passwd -6 -stdin to generate it"
}
