terraform {
  required_version = ">= 1.13.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
<<<<<<< HEAD
      version = "~> 0.90.0"
=======
      version = "~> 0.91.0"
>>>>>>> dd182c05d5de176d62cb2962d4436412bf1034af
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.6.0"
    }
  }
}
