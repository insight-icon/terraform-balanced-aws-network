variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

resource "random_pet" "this" {
  length = 4
}

//variable "public_key_path" {}

module "defaults" {
  source      = "../.."
  id          = random_pet.this.id
  bucket_name = random_pet.this.id
  //  public_key_paths = [var.public_key_path]
}

module "ami" {
  source = "github.com/insight-infrastructure/terraform-aws-ami"
}

resource "aws_instance" "this" {
  ami                    = module.ami.ubuntu_2004_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.defaults.sg_eks_id]
  subnet_id              = module.defaults.public_subnets[0]
}
