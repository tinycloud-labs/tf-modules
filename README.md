[![TF Lint](https://github.com/tinycloud-labs/tf-modules/actions/workflows/lint.yml/badge.svg)](https://github.com/tinycloud-labs/tf-modules/actions/workflows/lint.yml)
[![TF Test](https://github.com/tinycloud-labs/tf-modules/actions/workflows/test.yml/badge.svg)](https://github.com/tinycloud-labs/tf-modules/actions/workflows/test.yml)
[![Release Please](https://github.com/tinycloud-labs/tf-modules/actions/workflows/release-please.yml/badge.svg)](https://github.com/tinycloud-labs/tf-modules/actions/workflows/release-please.yml)

# tf-modules

Reusable Terraform modules for my Proxmox homelab, built on the [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest) provider.

## Modules

| Module | Path | Tag prefix | Description |
| --- | --- | --- | --- |
| VM | [`proxmox/vm`](proxmox/vm) | `vm-v*` | Cloud-init VM from a cloud image |
| LXC | [`proxmox/lxc`](proxmox/lxc) | `lxc-v*` | LXC container from a template |
| Cloud image | [`proxmox/cloud-img-download`](proxmox/cloud-img-download) | `image-v*` | Downloads a cloud image to a Proxmox datastore |
| Tags | [`proxmox/tags`](proxmox/tags) | `tags-v*` | Builds a consistent set of Proxmox tags (no resources) |

## Usage

Pin each module to its own release tag:

```hcl
module "vm" {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//proxmox/vm?ref=vm-v3.0.0"
  # ...
}
```

Available versions are on the [releases page](https://github.com/tinycloud-labs/tf-modules/releases), and each module has its own `CHANGELOG.md`.

## Releases

Releases are automated with [release-please](https://github.com/googleapis/release-please). Each module is versioned independently, so use [Conventional Commits](https://www.conventionalcommits.org/) in PR titles:

- `fix:` → patch
- `feat:` → minor
- `feat!:` or a `BREAKING CHANGE:` footer → major
- `chore:`, `docs:`, `ci:` → no release

Merging to `main` opens or updates a release PR per module. Merging that PR tags the release and updates the module's changelog.

## Development

Requires Terraform `>= 1.13` and [TFLint](https://github.com/terraform-linters/tflint).

```bash
terraform fmt -recursive
tflint --init && tflint --recursive --config "$PWD/.tflint.hcl"
```

### Tests

Each module has native Terraform tests in `tests/*.tftest.hcl`. Providers are mocked, so the tests need no Proxmox access:

```bash
cd proxmox/vm
terraform init -backend=false
terraform test
```

They check the module's own logic (inputs, validations, derived values), not whether Proxmox accepts the config.

CI runs the lint and test checks on every PR that touches `proxmox/**`.
