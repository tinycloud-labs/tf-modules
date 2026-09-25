terraform {
  required_version = "~> 1.15.0"
  backend "local" {
    path = "./test.tfstate"
  }
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }
}
provider "proxmox" {
  endpoint = "https://10.10.50.20:8006/"
  username = "${var.pve_user}@pam"
  password = var.pve_pwd
  insecure = true
  ssh {
    agent       = false
    private_key = file("${var.id_rsa}")
    username    = var.pve_user
    node {
      name    = "pve1"
      address = "10.10.50.20"
    }
  }
}

module "smoke_test" {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//proxmox/vm?ref=smbios-support"

  description         = "Test"
  proxmox_node_name   = "pve1"
  disk_name           = "tank"
  ssh_public_key_path = var.id_rsa_pub
  hostname            = "test01"
  timezone            = "America/Los_Angeles"
  cloud_image_info    = ["synology", "debian-13-generic-amd64-20260831-2587.qcow2.img"]
  disk_size           = "20"
  memory              = 1028
  mac_address         = "32:fe:ce:8c:3b:a8"
  snippet_store_id    = "local-lvm"
  file_format         = "raw"
  vm_id               = 201
  enable_smbios       = true
}
