
variable "enable_k8s" {
  description = "Enable eks"
  type        = bool
  default     = true
}

resource "aws_security_group" "eks" {
  count = var.create && var.enable_k8s ? 1 : 0

  name   = "eks-${var.id}"
  tags   = var.tags
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "eks_bastion_ssh" {
  count = var.create && var.enable_bastion ? 1 : 0

  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = join("", aws_security_group.eks.*.id)
  source_security_group_id = join("", aws_security_group.bastion_private.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_egress" {
  count = var.create && var.enable_bastion ? 1 : 0

  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.eks.*.id)
  type              = "egress"
}