packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.4"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "config_file" {
  type    = string
  default = "jammy"
}

variable "cpu" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "40000"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
}

variable "iso_url" {
  type    = string
  default = "http://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"

}

variable "name" {
  type    = string
  default = "jammy"
}

variable "ram" {
  type    = string
  default = "8192"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "version" {
  type    = string
  default = ""
}