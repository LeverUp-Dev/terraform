resource "aws_security_group" "allow_asg" {
  name        = "allow_asg"
  description = "Allow ASG http, ssh inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_asg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_asg_http" {
  security_group_id = aws_security_group.allow_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_asg_ssh" {
  security_group_id = aws_security_group.allow_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_asg_outall" {
  security_group_id = aws_security_group.allow_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

data "aws_ami" "amazon" {
  most_recent      = true
  owners           = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "myLT" {
  name = "myLT"

  image_id = data.aws_ami.amazon.id
  instance_type = "t3.micro"
  update_default_version = true
  key_name = "mykeypair"

  vpc_security_group_ids = [aws_security_group.allow_asg.id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    db_address = var.db_address,
    db_username = var.db_username,
    db_password = var.db_password
  }))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "myLT-instance"
    }
  }
}

resource "aws_autoscaling_group" "myASG" {
  name                      = "myASG"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2

  health_check_grace_period = 300
  health_check_type         = "ELB"

  force_delete              = true

  target_group_arns = var.target_group_arns

  vpc_zone_identifier       = var.vpc_zone_identifier
  
  launch_template {
    id      = aws_launch_template.myLT.id
    version = "$Latest"
  }
}
