resource "aws_security_group" "msk" {
  count = 1

  vpc_id = module.vpc.vpc_id
  name   = "${var.id}-msk-sg"
  tags   = var.tags
}

resource "aws_security_group_rule" "zookeeper" {
  count                    = 1
  from_port                = 2181
  to_port                  = 2181
  protocol                 = "tcp"
  security_group_id        = join("", aws_security_group.msk.*.id)
  source_security_group_id = join("", aws_security_group.eks.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "kafka_9094" {
  count                    = 1
  from_port                = 9094
  to_port                  = 9094
  protocol                 = "tcp"
  security_group_id        = join("", aws_security_group.msk.*.id)
  source_security_group_id = join("", aws_security_group.eks.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "kafka_9092" {
  count                    = 1
  from_port                = 9092
  to_port                  = 9092
  protocol                 = "tcp"
  security_group_id        = join("", aws_security_group.msk.*.id)
  source_security_group_id = join("", aws_security_group.eks.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "msk_egress" {
  count             = 1
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.msk.*.id)
  type              = "egress"
}
