resource "helm_release" "csi_driver_nfs" {
  name       = "external-secrets"
  namespace  = var.kube_namespace
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "1.2.1"
}
