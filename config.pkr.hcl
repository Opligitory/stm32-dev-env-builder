source "qemu" "jammy" {
  accelerator            = "kvm"
  boot_command           = [
    "<esc><esc><esc><esc>e<wait>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "<del><del><del><del><del><del><del><del>", 
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/${var.config_file}/\"<enter><wait>", 
    "initrd /casper/initrd<enter><wait>", 
    "boot<enter>", 
    "<enter><f10><wait>"
  ]

  boot_wait              = "3s"
  disk_cache             = "none"
  disk_compression       = true
  disk_discard           = "ignore"
  disk_interface         = "virtio"
  disk_size              = var.disk_size
  format                 = "qcow2"
  headless               = var.headless
  host_port_max          = 2229
  host_port_min          = 2222
  http_directory         = "."
  http_port_max          = 10089
  http_port_min          = 10082
  iso_checksum           = var.iso_checksum
  iso_url                = var.iso_url
  net_device             = "virtio-net"
  output_directory       = "artifacts/qemu/${var.name}${var.version}.qcow2"
  qemu_binary            = "/usr/bin/qemu-system-x86_64"
  qemuargs               = [["-m", "${var.ram}M"], ["-smp", "${var.cpu}"]]
  shutdown_command       = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_password           = var.ssh_password
  ssh_username           = var.ssh_username
  ssh_handshake_attempts = 500
  ssh_timeout            = "45m"
  ssh_wait_timeout       = "45m"
}

build {
  sources = ["source.qemu.jammy"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    inline          = [
      "sudo apt-get update", 
      "sudo apt-get -y install software-properties-common", 
      "sudo apt-add-repository --yes --update ppa:ansible/ansible", 
      "sudo apt update", 
      "sudo apt -y install ansible"
    ]
  }

/*
  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    inline          = ["sudo apt -y remove ansible", "sudo apt-get clean", "sudo apt-get -y autoremove --purge"]
  }

  post-processor "shell-local" {
    environment_vars = ["IMAGE_NAME=${var.name}", "IMAGE_VERSION=${var.version}", "DESTINATION_SERVER=${var.destination_server}"]
    script           = "scripts/push-image.sh"
  }
*/

  provisioner "file" {
    source      = "http/stm32_tools"
    destination = "/home/${var.ssh_username}/Downloads"
  }

  provisioner "ansible-local" {
    playbook_dir  = "ansible"
    playbook_file = "ansible/install-stm32-dev-deps.yml"
  }


  provisioner "breakpoint" {
    disable = true
    note    = "Manually install STM32 tools now."
  }

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    inline          = [
      "sudo rm /etc/netplan/00-installer-config*yaml",
      "sudo printf 'network:\n  version: 2\n  renderer: NetworkManager' > /etc/netplan/01-network-manager-all.yaml"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    provider_override   = "libvirt"
    output              = "artifacts/qemu/${var.name}${var.version}.box"
  } 

}