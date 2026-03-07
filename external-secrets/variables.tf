variable "kube_namespace" {
  description = "Kubernetes namespace for csi-driver-nfs"
  type        = string
  default     = "external-secrets"
}

variable "config_path" {
  description = "Path to the Kubernetes config file"
  type        = string
  default     = null
}

variable "config_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = null
}

variable "create_namespace" {
  description = "Whether to create namespace"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "ESO chart version"
  type        = string
  default     = "1.3.2"
}

variable "helm_set_values" {
  description = "Optional Helm set values"
  type        = map(string)
  default     = {}
}
