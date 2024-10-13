// we will use module to create vpc , from registry.terraform.io

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.VPC-NAME
  cidr = var.VPC-CIDR

  azs             = [var.ZONE1, var.ZONE2, var.ZONE3]
  private_subnets = [var.PRIV-SUB-1, var.PRIV-SUB-2, var.PRIV-SUB-3]
  public_subnets  = [var.PUB-SUB-1, var.PUB-SUB-2, var.PUB-SUB-3]

  enable_nat_gateway   = true
  single_nat_gateway   = true // beacuse it will create multiple nat gateway if we don't say single
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  vpc_tags = {
    name = var.VPC-NAME
  }
}
