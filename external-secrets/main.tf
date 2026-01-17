resource "helm_release" "external-secrets" {
  name             = "external-secrets"
  namespace        = var.kube_namespace
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "1.2.1"
  create_namespace = var.create_namespace
}
