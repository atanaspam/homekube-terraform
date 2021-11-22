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

variable "controller_static_ip_mappings" {
  type        = map(any)
  description = "Static IP mappings for each node in the cluster. This is configurable so that you can have full control over the network setup of your nodes. The info here should match the static mappings in your DHCP server."
  default = {
    0 = { "mac" = "00:50:56:80:f3:20"},
    # 1 = {"mac" = "00:50:56:80:f3:21"},
    # 2 = {"mac" = "00:50:56:80:f3:22"},
  }
}

variable "worker_static_ip_mappings" {
  type        = map(any)
  description = "Static IP mappings for each node in the cluster. This is configurable so that you can have full control over the network setup of your nodes. The info here should match the static mappings in your DHCP server."
  default = {
    0 = { "mac" = "00:50:56:80:f3:2d"},
    # 1 = {"mac" = "00:50:56:80:f3:2c"},
    # 2 = {"mac" = "00:50:56:80:f3:2b"},
  }
}
