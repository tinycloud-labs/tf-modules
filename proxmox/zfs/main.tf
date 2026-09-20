resource "proxmox_storage_zfspool" "this" {
  id    = var.pool_id
  nodes = var.nodes

  zfs_pool       = var.zfs_pool
  content        = var.content
  thin_provision = var.thin_provisioning
  blocksize      = var.block_size
}
