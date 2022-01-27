# Packer VM Image template

All the packer configuration required to build the base image for the Kubernetes nodes can be found in this directory.

## Building a base image

There is a fair bit of confiuration that goes into packer. You can specify that by creating a `variables.pkrvars.hcl` file in the `packer` folder and adding the contents below to it.

```hcl
vcenter_server       = "<URL to vCenter Server where VM template will be uploaded>"
vcenter_username     = "<Username for authenticating to vCenter>"
vcenter_password     = "<Password for authenticating to vCenter>"
datastore_name       = "<Name of the DataStore to be used when uploading the VM template>"
datacenter_name      = "<Name of the datacenter where the template will be uploaded>"
network_name         = "<Name of the Network to be used by the VM template>"
vm_name              = "<Name of VM created on your local machine>"
vm_ssh_username      = "<Username to be used to SSH to the template VM>"
vm_ssh_password      = "<Password to be used to SSH to the template VM>"
vm_ssh_password_hash = "<Hashed version of the password above using openssl passwd -6 -stdin (works on Debian systems only)>"
```

You can also refer to the `variables.pkr.hcl` file for a detailed description of what each of those values should be.

```bash
packer init .
packer build -on-error=ask -var-file="variables.pkrvars.hcl" .
```

## Custom bootstrap scripts

The ability to run custom scripts after the cluster is created is provided via the `bootstrap.sh` script. This scirpt can be custom for anyone using this repository.

## References

https://github.com/vmware-samples/packer-examples-for-vsphere/tree/main/builds/linux/ubuntu/20-04-lts
