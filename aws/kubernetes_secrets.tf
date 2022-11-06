resource "kubernetes_secret" "zerossl_eab_hmac_key" {
  provider   = kubernetes
  depends_on = [module.eks]
  metadata {
    name      = "zerossl-eab-hmac-key"
    namespace = "cert-manager"
  }

  data = {
    secret = var.zerossl_eab_hmac_key
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "zerossl_eab_key_id" {
  provider   = kubernetes
  depends_on = [module.eks]
  metadata {
    name      = "zerossl-eab-hmac-key-id"
    namespace = "cert-manager"
  }

  data = {
    secret = var.zerossl_eab_key_id
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "argocd-tls" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema, helm_release.external-dns, kubernetes_namespace.cinema]
  metadata {
    name = "argocd-tls"
    namespace = "istio-system"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]
  }
}

resource "kubernetes_secret" "wayofthesys-tls" {
  provider   = kubernetes
  depends_on = [digitalocean_kubernetes_cluster.cinema, helm_release.external-dns, kubernetes_namespace.cinema]
  metadata {
    name      = "${replace(var.domain_name[0], ".", "-")}-tls"
    namespace = "istio-system"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]
  }
}
