resource "aws_eip" "nlb_eip" {
  count = 2
  vpc   = true
  tags  = var.default_tags
}

resource "aws_lb" "network_lb" {
  name               = "bastion-nlb"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = var.bastion_subnet_1
    allocation_id = aws_eip.nlb_eip[0].id
  }

  subnet_mapping {
    subnet_id     = var.bastion_subnet_2
    allocation_id = aws_eip.nlb_eip[1].id
  }

  enable_deletion_protection = false
  tags                       = var.default_tags
}

resource "aws_lb_target_group" "nlb_tg" {
  name     = "bastion-nlb-default"
  port     = 22
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "nlb_listener_22" {
  load_balancer_arn = aws_lb.network_lb.arn
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

resource "aws_autoscaling_attachment" "nlb_attachment" {
  alb_target_group_arn   = aws_lb_target_group.nlb_tg.arn
  autoscaling_group_name = aws_autoscaling_group.bastion_as_group.id
}