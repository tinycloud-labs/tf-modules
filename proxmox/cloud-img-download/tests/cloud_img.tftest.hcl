# Unit tests: the provider is mocked, so nothing is downloaded and no Proxmox API access is needed.

mock_provider "proxmox" {}

variables {
  cloud_image_url   = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  storage_pool      = "local"
  proxmox_node_name = "pve"
}

run "download_file" {
  command = plan

  assert {
    condition     = proxmox_download_file.this.file_name == "debian-12-generic-amd64.qcow2.img"
    error_message = "File name should be the URL's last path segment plus .img."
  }

  assert {
    condition     = proxmox_download_file.this.content_type == "iso"
    error_message = "Cloud images should be stored as iso content."
  }

  assert {
    condition     = proxmox_download_file.this.datastore_id == "local" && proxmox_download_file.this.node_name == "pve"
    error_message = "Datastore and node should pass through."
  }

  assert {
    condition     = proxmox_download_file.this.url == var.cloud_image_url
    error_message = "URL should pass through unchanged."
  }
}
