resource "aws_security_group" "allow_alb" {
  name        = "allow_alb"
  description = "Allow web inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_http" {
  security_group_id = aws_security_group.allow_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_alb_all" {
  security_group_id = aws_security_group.allow_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_lb_target_group" "myLB_TG" {
  name     = "myLB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb" "myLB" {
  name               = "myLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_alb.id]
  subnets            = var.subnets
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.myLB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myLB_TG.arn
  }
}
