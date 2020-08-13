######
# VPC
######
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = ""
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = []
}

variable "num_azs" {
  description = "The number of AZs to deploy into"
  type        = number
  default     = 3
}

variable "cidr" {
  description = "The cidr range for network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "The subnet ranges"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "private_subnets" {
  description = "The subnet ranges"
  type        = list(string)
  default     = ["10.1.100.0/20", "10.0.116.0/20", "10.0.132.0/20"]
}


module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v2.15.0"
  name   = var.vpc_name

  tags = var.tags

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  azs  = var.azs
  cidr = var.cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.id}" = "shared"
    "kubernetes.io/role/elb"          = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.id}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}