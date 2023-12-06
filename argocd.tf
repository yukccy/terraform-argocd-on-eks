resource "kubernetes_namespace_v1" "argocd_namespace" {
  metadata {
    name = var.argocd_target_namespace
  }

  depends_on = [ module.eks ]
}

resource "helm_release" "argocd" {
  name = var.argocd_deploy_name
  repository = var.argocd_helm_repo_url
  chart = var.argocd_helm_chart_name
  namespace = var.argocd_target_namespace
  cleanup_on_fail = true
  depends_on = [ helm_release.alb-controller, kubernetes_namespace_v1.argocd_namespace ]

  set {
    # Run server without TLS
    name  = "configs.params.server\\.insecure"
    value = var.argocd_server_insecure
  }

}

resource "kubernetes_ingress_v1" "argocd_ingress" {
  metadata {
    name = "argocd-ingress"
    namespace = "argocd"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [ helm_release.argocd, module.eks, module.lbc_role, module.vpc, kubernetes_namespace_v1.argocd_namespace ]
}