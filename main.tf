terraform {
  required_version = "~> 1.0.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    vsphere = {
      source  = "registry.terraform.io/hashicorp/vsphere"
      version = ">=1.24.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

# TODO FIXME
terraform {
  backend "local" {
    path = "/Users/atanaspam/Documents/Projects/homelab-terraform/terraform.tfstate"
  }
}

provider "vsphere" {
  #vsphere_server = "10.1.1.109"

  # If you have a self-signed cert on vsphere
  allow_unverified_ssl = true
}

provider "random" {}

provider "null" {}
