locals {
  all_tags = {
    env     = var.environment
    cluster = var.cluster
    flavor  = var.flavor
    os      = var.os
    role    = var.role
    size    = var.size
  }

  # Proxmox tags are a flat list, so empty optional values are dropped entirely.
  tags = tomap({ for key, value in local.all_tags : key => value if value != "" })
}
