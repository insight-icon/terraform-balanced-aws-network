resource "aws_security_group" "bastion_public" {
  count       = var.create && var.enable_bastion ? 1 : 0
  description = "Enable SSH access to the bastion host from external via SSH port"

  vpc_id = module.vpc.vpc_id
  name   = "${var.id}-bastion-public-sg"
  tags   = var.tags
}

resource "aws_security_group_rule" "bastion_ssh_public" {
  count             = var.create && var.enable_bastion ? 1 : 0
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = join("", aws_security_group.bastion_public.*.id)
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_egress" {
  count             = var.create && var.enable_bastion ? 1 : 0
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.bastion_public.*.id)
  type              = "egress"
}

resource "aws_security_group" "bastion_private" {
  count = var.create && var.enable_bastion ? 1 : 0

  description = "Enable SSH access to the bastion host from private hosts via SSH port"

  vpc_id = module.vpc.vpc_id
  name   = "${var.id}-bastion-private-sg"
  tags   = var.tags
}

resource "aws_security_group_rule" "bastion_ssh_private" {
  count                    = var.create && var.enable_bastion ? 1 : 0
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = join("", aws_security_group.bastion_private.*.id)
  source_security_group_id = join("", aws_security_group.bastion_public.*.id)
  type                     = "ingress"
}