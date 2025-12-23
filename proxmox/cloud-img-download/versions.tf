terraform {
  required_version = ">= 1.13.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.89.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.6.0"
    }
  }
}
