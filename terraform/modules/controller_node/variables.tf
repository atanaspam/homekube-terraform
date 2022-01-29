variable "node_num" {
  type        = number
  description = "The unique number of this node."
}

variable "mac_address" {
  type        = string
  description = "The MAC addrress to be used for this node's network interface."
}

variable "datacenter_name" {
  type        = string
  description = "The name of the vSphere datacenter where kubernetes will be deployed."
}

variable "datastore_name" {
  type        = string
  description = "The name of the vSphere datastore that will be used for the kubernetes VMs."
}

variable "cluster_name" {
  type        = string
  description = "The name of the vSphere cluster where kubernetes VMs will be deployed."
}

variable "network_name" {
  type        = string
  description = "The name of the vSphere network that will be used by the kubernetes VMs."
}

variable "vm_ssh_username" {
  type = string
}

variable "vm_ssh_password" {
  type      = string
  sensitive = true
}

variable "bring_your_own_ca" {
  type    = bool
  default = true
}

variable "discovery_token_ca_cert_hash" {
  type        = string
  description = "The cert hash used in the node join process. Value is ignored if bring_your_own_ca is false. Can be generated if you are using your own CA."
}

variable "kubeadm_join_token" {
  type        = string
  description = "The token used in the node join process"
}

variable "target_subnet" {
  type        = string
  description = "The target subnet where the kubernetes cluster will be deployed. This needs to be a routable /24 subnet that is not used by anything else."

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(0)$", var.target_subnet))
    error_message = "The subnet def should end with a 0, and should not include the mask definition. For example 10.1.4.0 ."
  }
}
