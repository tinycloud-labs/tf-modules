resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.kube_namespace
  create_namespace = true
  version          = var.chart_version

  set = [{
    name  = "prometheus.enabled"
    value = var.enabled_prometheus
    },
    {
      name  = "crds.enabled"
      value = "true"
    },
    {
      name  = "crds.keep"
      value = "false"
  }]

  values = [
    yamlencode({
      global = {
        commonLabels = {
          "app.kubernetes.io/managed-by" = "terraform"
        }
      }
    })
  ]
}
