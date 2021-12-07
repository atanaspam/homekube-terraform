source "vmware-iso" "ubuntu_base" {
  cpus         = 4
  memory       = 8192
  boot_command = ["<esc><esc><esc><esc>e<wait>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\"<enter><wait>", "initrd /casper/initrd<enter><wait>", "boot<enter>", "<enter><f10><wait>"]
  boot_wait    = "5s"
  headless     = false
  http_content = {
    "/meta-data" = file("http/meta-data")
    "/user-data" = templatefile("http/user-data", { username = var.vm_ssh_username, password = var.vm_ssh_password_hash })
  }
  insecure_connection    = "true"
  iso_checksum           = "sha256:e4089c47104375b59951bad6c7b3ee5d9f6d80bfac4597e43a716bb8f5c1f3b0"
  iso_urls               = ["iso/ubuntu-21.04-live-server-amd64.iso", "https://releases.ubuntu.com/21.04/ubuntu-21.04-live-server-amd64.iso"]
  shutdown_command       = "sudo shutdown -P now"
  ssh_handshake_attempts = "100"
  ssh_username           = var.vm_ssh_username
  ssh_password           = var.vm_ssh_password
  ssh_port               = 22
  ssh_timeout            = "400m"
  guest_os_type          = "ubuntu64Guest"
  # disk_size             = 16384
  disk_type_id = 0
}

build {
  sources = ["source.vmware-iso.ubuntu_base"]

  # Clean up the existing cloud init folder. This will allow us to use it again when the template is used
  provisioner "shell" {
    inline = ["sudo rm -rf /var/lib/cloud/"]
  }

  post-processors {
    post-processor "vsphere" {
      keep_input_artifact = true
      vm_name             = "ubuntu_base"
      vm_folder           = "Templates"
      disk_mode           = "thin"
      vm_network          = var.network_name
      cluster             = var.vcenter_server
      host                = var.vcenter_server
      datacenter          = var.datacenter_name
      datastore           = var.datastore_name
      esxi_host           = "10.1.1.105"
      password            = var.vcenter_password
      username            = var.vcenter_username
      overwrite           = true
      insecure            = true
      # options    = [
      #   "--diskSize=16384"
      # ]
    }

    post-processor "vsphere-template" {
      host       = var.vcenter_server
      datacenter = var.datacenter_name
      password   = var.vcenter_password
      username   = var.vcenter_username
      insecure   = true
    }
  }
}
