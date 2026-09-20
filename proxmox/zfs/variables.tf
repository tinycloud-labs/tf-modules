variable "pool_id" {
  type = string
  description = "The unique identifier of the zfs pool storage"
}

variable "nodes" {
  type = list(string)
  description = " A list of nodes where this storage is available"
}

variable "zfs_pool" {
  type = string
  description = "The name of the ZFS storage pool to use (e.g. tank, rpool/data)"
}

variable content {
  type = list(string)
  description = "The content types that can be stored on this storage. Valid values: backup (VM backups), images (VM disk images), import (VM disk images for import), iso (ISO images), rootdir (container root directories), snippets (cloud-init, hook scripts, etc.), vztmpl (container templates)."
}

variable "thin_provisioning" {
  type = bool
  description = "Whether to enable thin provisioning (on or off). Thin provisioning allows flexible disk allocation without pre-allocating full space"
  default = true
}

variable "block_size" {
  type = string
  description = "Block size for newly created volumes (e.g. 4k, 8k, 16k). Larger values may improve throughput for large I/O, while smaller values optimize space efficiency."
}

