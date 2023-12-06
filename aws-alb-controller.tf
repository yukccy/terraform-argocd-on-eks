module "lbc_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  create_role = true

  role_name = "${var.env_name}_eks_lbc"
  
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.alb_controller_target_namespace}:${var.alb_controller_deploy_name}"]
    }
  }
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name = var.alb_controller_deploy_name
    namespace = var.alb_controller_target_namespace
    labels = {
      "app.kubernetes.io/name" = var.alb_controller_deploy_name
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.lbc_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "alb-controller" {
  name = var.alb_controller_deploy_name
  repository = var.alb_controller_helm_repo_url
  chart = var.alb_controller_helm_chart_name
  namespace = var.alb_controller_target_namespace
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name = "region"
    value = var.aws_region
  }

  set {
    name = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name = "image.repository"
    value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name = "serviceAccount.create"
    value = "false"
  }

  set {
    name = "serviceAccount.name"
    value = kubernetes_service_account.service-account.metadata[0].name
  }

  set {
    name = "clusterName"
    value = module.eks.cluster_name
  }
}