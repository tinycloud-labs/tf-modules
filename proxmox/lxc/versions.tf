terraform {
  required_version = "~> 1.17.0"
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
      version = "~> 3.9.0"
    }
  }
}
