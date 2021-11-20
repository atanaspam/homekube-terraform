# vSphere / vCenter related configuration

Another prerequisite for using this automation is having a vSphere hypervisor with an optional vCenter Server deployment. This is required because there are very limited capabilities within the ESXi hypervisor API. Most of the API actions seem to be reserved for the paid vSphere. If you only have an ESXi hypervisor and are interested in upgrading for learing purposes you can check out the VMUG Advantage [here](https://www.vmug.com/membership/vmug-advantage-membership/).

## Create a user for terraform

In order to conform to least privilige standards it is best to have a separate user for terraform and provide it only with the necessary permissions for the deployment of new VMs.

Since have a vCenter Server Appliance deployed within my homelab I used the UI to manually create a new user and assign it the appropriate role.

### Create a `terraform` user

1. Navigate to `Administration`
2. Click on `Single Sign On` and `Users and Groups`
3. Select the appropriate domain (I dont really have SSO enabled so I am using the default `vsphere.local`)
4. Click on `Add User`
5. Set the `Username` to `terraform` and the `Password` to a secure password. The rest you can leave blank

### Create a `terraform` role

1. Navigate to `Administration`
2. Click on `Access Control` and `Roles`
3. Clock on the `VMOperator Controller Manager` role and then on `Clone role action`
4. Set `Role name` to a name of your choice for ex: `terraform` and submit
5. Find and edit the newly created `terraform` role
6. In the `Edit role` screen find the `Host` category and check `Delete virtual machine`, `Reconfigure virtual machine` and `Create virtual machine`
7. Click `next` and `finish` to save the changes

### Assign a role to the `terraform` user

1. Navigate to `Administration`
2. Click on `Access Control` and `Global Permissions`
3. Click on the `+` sign
4. Set `Domain` to your domain, `User/Group` to `terraform` and the role to `terraform`
5. Make sure `Propagate to children` is checked
