module "external_dns" {
  depends_on = [module.eks]
  source     = "git::https://github.com/lablabs/terraform-aws-eks-external-dns"

  enabled = true

  helm_release_name = "external-dns"
  namespace         = "external-dns"

  values = yamlencode({
    "LogLevel" : "debug"
    "provider" : "aws"
    "registry" : "txt"
    "txtOwnerId" : "eks-cluster"
    "txtPrefix" : "external-dns"
    "policy" : "sync"
    "domainFilters" : [
      var.domain_name[0]
    ]
    "publishInternalServices" : "true"
    "triggerLoopOnEvent" : "true"
    "interval" : "5s"
    "podLabels" : {
      "app" : "aws-external-dns-helm"
    }
    "sources" : [
      "ingress",
      "service",
      "istio-gateway"
    ]
    "istio-ingress-gateway" : "istio-system/istio-ingressgateway"
  })

  helm_timeout = 240
  helm_wait    = true

  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
}
