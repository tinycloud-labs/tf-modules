terraform {
  # Lower bounds are the oldest tested versions; upper bounds block the next major.
  required_version = ">= 1.13.0, < 2.0.0"
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      # bpg/proxmox 1.0 renames resources (proxmox_virtual_environment_* -> proxmox_*).
      version = ">= 0.111.0, < 1.0.0"
    }
  }
}
