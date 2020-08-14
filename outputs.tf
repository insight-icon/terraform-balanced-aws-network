#####
# sgs
#####
output "sg_bastion_public_id" {
  value = join("", aws_security_group.bastion_public.*.id)
}

output "sg_bastion_private_id" {
  value = join("", aws_security_group.bastion_private.*.id)
}

output "sg_eks_id" {
  value = join("", aws_security_group.eks.*.id)
}

output "sg_prometheus_id" {
  value = join("", aws_security_group.prometheus.*.id)
}

output "sg_rds_id" {
  value = join("", aws_security_group.rds.*.id)
}

output "sg_msk_id" {
  value = join("", aws_security_group.msk.*.id)
}

#########
# Bastion
#########
output "key_names" {
  value = aws_key_pair.bastion.*.key_name
}


#####
# VPC
#####
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnet_cidr_blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "azs" {
  value = module.vpc.azs
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}
