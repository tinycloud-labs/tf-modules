locals {
  helm_values = []
}

resource "helm_release" "this" {
  name             = var.release_name
  namespace        = var.kube_namespace
  repository       = var.helm_repository
  chart            = var.chart
  version          = var.chart_version
  create_namespace = var.create_namespace

  set = [
    for k, v in var.helm_set_values : {
      name  = k
      value = v
    }
  ]
}
