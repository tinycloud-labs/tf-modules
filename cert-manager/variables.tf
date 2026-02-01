variable "kube_namespace" {
  default     = "cert-manager"
  type        = string
  description = "Namespace where the cert-manager will be deployed"
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

variable "chart_version" {
  description = "Cert manager chart version"
  type        = string
  default     = "v1.19.2"
}

variable "enabled_prometheus" {
  description = "Whether to enable Prometheus metrics collection for cert manager (true/false as strings)"
  type        = string
  default     = "false"
}
