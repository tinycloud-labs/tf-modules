locals {
  helm_values = []
}

resource "helm_release" "external-secrets" {
  name             = "external-secrets"
  namespace        = var.kube_namespace
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = var.chart_version
  create_namespace = var.create_namespace

  set = [
    for k, v in var.helm_set_values : {
      name  = k
      value = v
    }
  ]
}
