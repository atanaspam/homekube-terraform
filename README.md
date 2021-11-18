# HomeKube Terrafrorm

An opinionated infrastructure as code homelab kubernetes cluster on vSphere.

## Background

Usually spinning up a kubernetes cluster within a non-enterprise "on premises" environment such as homelab involves a fair bit of manual work. This project aims to automate as many steps as possible in this process so that one spends less time on the infrastructure and more time on kubernetes itself. In adition to that this is also a great opportunity to learn how to bridge the gap between homelabs and current offerings within the cloud.

## How it works

TODO

## Prerequisites

This is an opinionated setup because it is tailored to my homelab. As a result there are a bunch of prerequisites that need to be in place for the terraform code to work. Hopefully I will eventually manage to make the dependencies vendor agnostic in a way that allows anyone to configre their homelab and then use the code from this project, but this is not the case yet.

### Networking

I am using PfSense as my router and firerwall. Therefore the networking prerequisites are documented for PfSense specifically.
See: [Network config](docs/pfsense.md)

### Hypervisor

I am using vSphere as my hypervisor. This is really a prerequisite for doing proper infrastructure as code for VMWare products. I could use a workaround such as [this](https://github.com/josenk/terraform-provider-esxi) ESXi provider, or Proxmox but my personal preference is to use tools that are widely used in enterprises. Also its not really a homelab if it isn't overkill right?

Details on how to set up your vSphere hypervisor can be found [here](docs/vsphere.md).

### VM template creation

Spinning up VMs from scratch and installing them on VMs is a very expensive process. This is why we will be creating a base template for our VMs that we will reuse accross all our nodes and configure according to our needs. This process is already common within cloud envronments for multiple reasons such as boot time and security.

Instructions for creating your reusable image can be found [here](docs/vm-template.md).

### Certificate Authority

TODO

## Running locally

After all the prerequisites have been configured, all you need to do is run Terraform with the correct parameters.

Env vars required

```bash
VSPHERE_USER
VSPHERE_PASSWORD
VSPHERE_SERVER
TF_VAR_ssh_username
TF_VAR_ssh_password
TF_VAR_datacenter_name
TF_VAR_datastore_name
TF_VAR_cluster_name
TF_VAR_network_name
TF_VAR_num_controllers
TF_VAR_num_workers
```

```bash
terraform init
terraform apply
```
