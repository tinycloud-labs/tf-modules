## Usage
This Terraform module provides a standardized and consistent set of tags for compute resources. It does not provision any resources, it's just a bunch of variables with an output block to enforce uniform resource tagging across resources and centralize tag definitions.

There are two required tags: `env` and `os`, plus optional tags: `cluster`, `flavor`, `role`, and `size`.

Empty optional values are excluded from the output map.

## What problem does this module solve?

In most platforms, tags are key-value pairs, but in Proxmox, tags are just a flat list of strings. That might work fine when you're managing a few VMs, but once you start scaling up, it becomes messy fast. Without some structure, it’s easy to end up with inconsistent tags, making it harder to group or filter resources in the Proxmox UI.

This module helps solve that by letting you define consistent, standardized tags right in your Terraform code, so your tagging stays clean, even as your infrastructure grows.

Example usage:
```hcl
module "tags_group_1" {
  source      = "git::https://github.com/tinycloud-labs/tf-modules.git//proxmox/tags?ref=tags-v0.1.0"
  environment = "prod"
  cluster     = "main"
  flavor      = "k3s"
  os          = "debian12"
  role        = "worker"
}

module "tags_group_2" {
  source      = "git::https://github.com/tinycloud-labs/tf-modules.git//proxmox/tags?ref=tags-v0.1.0"
  environment = "dev"
  os          = "rhel7"
  role        = "proxy"
}

resource "proxmox_virtual_environment_vm" "vm_1" {
  name = "k8s-worker-01"
  tags = [for key, value in module.tags_group_1.tags : "${key}:${value}"]
}

resource "proxmox_virtual_environment_vm" "vm_2" {
  name = "some-big-beautiful-proxy"
  tags = [for key, value in module.tags_group_2.tags : "${key}:${value}"]
}
```

## Inputs

- `environment` - (string, required) Environment in which the VM is deployed (e.g., prod, test).
- `os` - (string, required) Operating system of the VM (e.g., debian12, ubuntu).
- `cluster` - (string) Cluster name the VM is part of. Default: `""`.
- `flavor` - (string) Kubernetes flavor (e.g., k3s, kubeadm). Default: `""`.
- `role` - (string) Role of the VM within the cluster or system. Default: `""`.
- `size` - (string) One of `small`, `medium`, `large`. Default: `""`.

## Outputs

- `tags` - A map of tag names to values, excluding empty values.

## Notes

- Empty values are excluded from the `tags` output to avoid unnecessary or redundant tags.
- Leave an optional input unset (or `""`) to omit that tag.
