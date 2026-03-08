variable "kube_namespace" {
  description = "Kubernetes namespace for csi-driver-nfs"
  type        = string
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
  description = "Chart version"
  type        = string
}

variable "helm_set_values" {
  description = "Optional Helm set values"
  type        = map(string)
  default     = {}
}

variable "release_name" {
  description = "Helm release name"
  type        = string
}

variable "helm_repository" {
  description = "Chart source repository"
  type        = string
}

variable "chart" {
  description = "Target chart name"
  type        = string
}

