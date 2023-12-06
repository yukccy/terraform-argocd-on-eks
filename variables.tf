######################################################################
## Core
variable "name_prefix" {
  type = string
  default = "eks-env"
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "aws_cred_file_path" {
  type = string
  default = "~/.aws/credentials"
}

variable "aws_cred_profile" {
  type = string
  default = "default"
}

variable "env_name" {
  type = string
  default = "dev"
}

variable "provisioner" {
  type = string
  default = "terraform"
}

######################################################################
## Network
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr_root_newbits" {
  type = number
  default = 4
}

variable "public_subnets_cidr_sub_newbits" {
  type = number
  default = 4
}

variable "private_subnets_cidr_root_newbits" {
  type = number
  default = 4
}

variable "private_subnets_cidr_sub_newbits" {
  type = number
  default = 4
}

######################################################################
## EKS
variable "cluster_version" {
  type = number
  default = 1.28
}

variable "cluster_addons" {
  type = map(object({
    most_recent = bool
    preserve = optional(bool)
  }))

  default = {
    coredns = {
      most_recent = true
      preserve = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
}

variable "default_instance_types" {
  type = list(string)
  default = [ "t3a.large" ]
}

variable "eks_managed_node_groups" {
  type = map(object({
    name = string
    min_size = number
    max_size = number
    desired_size = number
    instance_types = list(string)
  }))

  default = {
    "app-node" = {
      name = "app-ng-1"
      min_size = 1
      max_size = 1
      desired_size = 1
      instance_types = ["t3a.large"]
    }
  }
}

######################################################################
## AWS ALB Controller
variable "alb_controller_deploy_name" {
  type = string
  default = "aws-load-balancer-controller"
}

variable "alb_controller_helm_chart_name" {
  type = string
  default = "aws-load-balancer-controller"
}

variable "alb_controller_helm_repo_url" {
  type = string
  default = "https://aws.github.io/eks-charts"
}

variable "alb_controller_target_namespace" {
  type = string
  default = "kube-system"
}

######################################################################
## ArgoCD
variable "argocd_deploy_name" {
  type = string
  default = "argocd"
}

variable "argocd_helm_chart_name" {
  type = string
  default = "argo-cd"
}

variable "argocd_helm_repo_url" {
  type = string
  default = "https://argoproj.github.io/argo-helm"
}

variable "argocd_target_namespace" {
  type = string
  default = "argocd"
}

variable "argocd_server_insecure" {
  type = bool
  default = true
}