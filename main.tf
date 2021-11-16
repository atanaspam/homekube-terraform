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

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "vsphere" {
  # vsphere configuration is provided via environment variables

  # If you have a self-signed cert on vsphere
  allow_unverified_ssl = true
}

provider "random" {}

provider "null" {}
