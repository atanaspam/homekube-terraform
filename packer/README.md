# Packer VM Image template

More info on how to run and configure packer

## Running locally

There is a fair bit of confiuration that goes into packer. You can specify that by creating a `variables.pkrvars.hcl` file in the `packer` folder and adding the contents below to it.

```hcl
vcenter_server       = "<URL to vCenter Server where VM template will be uploaded>"
vcenter_username     = "<Username for authenticating to vCenter>"
vcenter_password     = "<Password for authenticating to vCenter>"
datastore_name       = "<Name of the DataStore to be used when uploading the VM template>"
datacenter_name      = "<Name of the datacenter where the template will be uploaded>"
network_name         = "<Name of the Network to be used by the VM template>"
vm_name              = "<Name of the template VM>"
vm_ssh_username      = "<Username to be used to SSH to the template VM>"
vm_ssh_password      = "<Password to be used to SSH to the template VM>"
vm_ssh_password_hash = "<Hashed version of the password above using openssl passwd -6>"
```

```bash
packer init
packer build -on-error=ask -var-file="variables.pkrvars.hcl" .
```
