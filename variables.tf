variable "ssh_username" {
  type = string
}

variable "ssh_password" {
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
