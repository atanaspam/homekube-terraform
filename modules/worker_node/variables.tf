variable "node_num" {
  type        = number
  description = "The unique number of this node."
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
