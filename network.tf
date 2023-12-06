locals {
    azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
    num_of_az = length(local.azs)
    subnet_cidr = cidrsubnets(var.vpc_cidr, var.public_subnets_cidr_root_newbits, var.private_subnets_cidr_root_newbits)
}

locals {
  public_subnets_list_cidr = cidrsubnets(local.subnet_cidr[0], [for i in range(local.num_of_az): var.public_subnets_cidr_sub_newbits]...)
  private_subnets_list_cidr = cidrsubnets(local.subnet_cidr[1], [for i in range(local.num_of_az): var.private_subnets_cidr_sub_newbits]...)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr

  azs = local.azs
  public_subnets  = local.public_subnets_list_cidr
  private_subnets = local.private_subnets_list_cidr

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = true
  create_igw = true
  map_public_ip_on_launch = true
}