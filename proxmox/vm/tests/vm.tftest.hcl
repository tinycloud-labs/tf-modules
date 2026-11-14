# Unit tests: all providers are mocked, so no Proxmox API access is needed.
# They check this module's own logic, not whether Proxmox accepts the config.

mock_provider "proxmox" {}
mock_provider "local" {}
mock_provider "random" {}

override_data {
  target = data.local_file.ssh_public_key
  values = {
    content = "ssh-ed25519 AAAAC3NzaTEST test@example\n"
  }
}

override_resource {
  target = random_string.random_cloud_init_id
  values = {
    result = "ab12"
  }
}

# The provider validates file IDs even when mocked, so give the snippet a realistic one.
override_resource {
  target = proxmox_virtual_environment_file.cloud_config
  values = {
    id = "local:snippets/cloud-init-config-test-vm-ab12.yaml"
  }
}

variables {
  proxmox_node_name   = "pve"
  hostname            = "test-vm"
  disk_name           = "local-lvm"
  disk_size           = "10"
  cloud_image_info    = ["local", "debian-12-generic.qcow2.img"]
  ssh_public_key_path = "unused-because-overridden"
  timezone            = "UTC"
  discard_disk        = "on"
  file_format         = "raw"
  snippet_store_id    = "local"
}

run "defaults" {
  command = plan

  assert {
    condition     = proxmox_virtual_environment_vm.vm_resource.disk[0].file_id == "local:iso/debian-12-generic.qcow2.img"
    error_message = "Disk file_id should be built from cloud_image_info."
  }

  assert {
    condition     = length(proxmox_virtual_environment_vm.vm_resource.smbios) == 0
    error_message = "No smbios block should be set unless enable_smbios is true."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.vm_resource.network_device[0].bridge == "vmbr0"
    error_message = "Default bridge should be vmbr0."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.vm_resource.cpu[0].type == "qemu64"
    error_message = "Default CPU type should be qemu64."
  }
}

run "cloud_init_snippet" {
  # apply (against mocks) so the snippet's file_name and rendered content are known.
  command = apply

  assert {
    condition     = proxmox_virtual_environment_file.cloud_config.source_raw[0].file_name == "cloud-init-config-test-vm-ab12.yaml"
    error_message = "Snippet name should include the hostname and random suffix."
  }

  assert {
    condition     = strcontains(proxmox_virtual_environment_file.cloud_config.source_raw[0].data, "hostname: test-vm")
    error_message = "cloud-init should set the hostname."
  }

  assert {
    condition     = strcontains(proxmox_virtual_environment_file.cloud_config.source_raw[0].data, "- ssh-ed25519 AAAAC3NzaTEST test@example\n")
    error_message = "cloud-init should contain the trimmed SSH public key."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.vm_resource.initialization[0].user_data_file_id == proxmox_virtual_environment_file.cloud_config.id
    error_message = "VM should use the generated cloud-init snippet."
  }
}

run "smbios_serial" {
  command = plan

  variables {
    vm_id         = 150
    enable_smbios = true
  }

  assert {
    condition     = proxmox_virtual_environment_vm.vm_resource.smbios[0].serial == "h=pve;i=150"
    error_message = "smbios serial should encode node name and VM ID."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.vm_resource.vm_id == 150
    error_message = "vm_id should pass through."
  }
}

run "static_mac" {
  command = plan

  variables {
    mac_address = "BC:24:11:AA:BB:CC"
  }

  assert {
    condition     = proxmox_virtual_environment_vm.vm_resource.network_device[0].mac_address == "BC:24:11:AA:BB:CC"
    error_message = "A provided MAC address should be set on the NIC."
  }
}

# -- Validation failures ----------

run "rejects_smbios_without_vm_id" {
  command = plan

  variables {
    enable_smbios = true
  }

  expect_failures = [var.enable_smbios]
}

run "rejects_vm_id_out_of_range" {
  command = plan

  variables {
    vm_id = 99
  }

  expect_failures = [var.vm_id]
}

run "rejects_fractional_vm_id" {
  command = plan

  variables {
    vm_id = 150.5
  }

  expect_failures = [var.vm_id]
}

run "rejects_multicast_mac" {
  command = plan

  variables {
    mac_address = "01:00:5E:00:00:01"
  }

  expect_failures = [var.mac_address]
}

run "rejects_dash_mac" {
  command = plan

  variables {
    mac_address = "BC-24-11-AA-BB-CC"
  }

  expect_failures = [var.mac_address]
}

run "rejects_invalid_hostname" {
  command = plan

  variables {
    hostname = "bad_host!"
  }

  expect_failures = [var.hostname]
}

run "rejects_invalid_disk_size" {
  command = plan

  variables {
    disk_size = "10G"
  }

  expect_failures = [var.disk_size]
}

run "rejects_invalid_discard" {
  command = plan

  variables {
    discard_disk = "off"
  }

  expect_failures = [var.discard_disk]
}
