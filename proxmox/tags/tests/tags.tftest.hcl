# No providers involved, so these tests need nothing but Terraform.

variables {
  environment = "prod"
  os          = "debian12"
}

run "required_only" {
  command = plan

  assert {
    condition     = output.tags == tomap({ env = "prod", os = "debian12" })
    error_message = "Only the required tags should be present when optional inputs are empty."
  }
}

run "all_tags" {
  command = plan

  variables {
    cluster = "main"
    flavor  = "k3s"
    role    = "worker"
    size    = "small"
  }

  assert {
    condition     = length(output.tags) == 6
    error_message = "All six tags should be present."
  }

  assert {
    condition     = output.tags["size"] == "small" && output.tags["cluster"] == "main"
    error_message = "Optional tags should pass through unchanged."
  }
}

run "proxmox_tag_list" {
  command = plan

  variables {
    role = "proxy"
  }

  # The pattern used in the README to turn the map into Proxmox tags.
  assert {
    condition     = sort([for k, v in output.tags : "${k}:${v}"]) == tolist(["env:prod", "os:debian12", "role:proxy"])
    error_message = "The README's key:value tag list pattern should work on the output."
  }
}

run "rejects_unknown_size" {
  command = plan

  variables {
    size = "huge"
  }

  expect_failures = [var.size]
}
