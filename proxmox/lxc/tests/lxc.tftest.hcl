# Unit tests: all providers are mocked, so no Proxmox API access is needed.

mock_provider "proxmox" {}
mock_provider "local" {}

override_data {
  target = data.local_file.ssh_public_key
  values = {
    content = "ssh-ed25519 AAAAC3NzaTEST test@example\n"
  }
}

variables {
  node_name           = "pve"
  hostname            = "test-ct"
  template_file_id    = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  ssh_public_key_path = "unused-because-overridden"
  disk_id             = "local-lvm"
}

run "defaults" {
  command = plan

  assert {
    condition     = proxmox_virtual_environment_container.lxc_container.initialization[0].ip_config[0].ipv4[0].address == "dhcp"
    error_message = "IPv4 should default to DHCP."
  }

  assert {
    condition     = proxmox_virtual_environment_container.lxc_container.initialization[0].user_account[0].keys == tolist(["ssh-ed25519 AAAAC3NzaTEST test@example"])
    error_message = "The SSH key should be trimmed and added to the default user."
  }

  assert {
    condition     = proxmox_virtual_environment_container.lxc_container.tags == tolist(["lxc"])
    error_message = "Tags should default to [\"lxc\"]."
  }

  assert {
    condition     = proxmox_virtual_environment_container.lxc_container.description == "Managed by Terraform"
    error_message = "Unexpected default description."
  }
}

run "static_ip" {
  command = plan

  variables {
    ipv4_config = "192.168.1.19/24"
  }

  assert {
    condition     = proxmox_virtual_environment_container.lxc_container.initialization[0].ip_config[0].ipv4[0].address == "192.168.1.19/24"
    error_message = "A static IPv4 address should pass through."
  }
}

run "template_and_disk" {
  command = plan

  variables {
    disk_size = "8"
    os_type   = "debian"
  }

  assert {
    condition     = proxmox_virtual_environment_container.lxc_container.operating_system[0].template_file_id == var.template_file_id
    error_message = "Template file ID should pass through."
  }

  assert {
    condition     = proxmox_virtual_environment_container.lxc_container.operating_system[0].type == "debian"
    error_message = "OS type should pass through."
  }

  assert {
    condition     = proxmox_virtual_environment_container.lxc_container.disk[0].size == 8
    error_message = "Disk size should pass through."
  }
}
