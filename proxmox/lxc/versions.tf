terraform {
  required_version = ">= 1.13.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.105.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.0"
    }
  }
}
