terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# 1. VPC 생성
resource "aws_vpc" "MyVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# myIGW
resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.MyVPC.id

  tags = {
    Name = "MyIGW"
  }
}

# routing table + route
resource "aws_route_table" "MyPublicRT" {
  vpc_id = aws_vpc.MyVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }

  tags = {
    Name = "MyPublicRT"
  }
}

# subnet
resource "aws_subnet" "MyPublicSN1" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "MyPublicSN1"
  }
}

resource "aws_subnet" "MyPublicSN2" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2c"

  tags = {
    Name = "MyPublicSN2"
  }
}

# aws_route_table_association
resource "aws_route_table_association" "MyPublicSNRouteTableAssociation" {
  subnet_id      = aws_subnet.MyPublicSN1.id
  route_table_id = aws_route_table.MyPublicRT.id
}

resource "aws_route_table_association" "MyPublicSNRouteTableAssociation2" {
  subnet_id      = aws_subnet.MyPublicSN2.id
  route_table_id = aws_route_table.MyPublicRT.id
}

# 2. SG 구성
resource "aws_security_group" "WEBSG" {
  name        = "WEBSG"
  description = "Allow http(80),ssh(22) inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.MyVPC.id

  tags = {
    Name = "WEBSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.WEBSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_22" {
  security_group_id = aws_security_group.WEBSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.WEBSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# 3. EC2 생성
data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_instance" "MYEC21" {
  ami           = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.WEBSG.id ]
  subnet_id   = aws_subnet.MyPublicSN1.id
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  hostname EC2-1
  yum install httpd -y
  service httpd start
  chkconfig httpd on
  echo "<h1>CloudNet@ EC2-1 Web Server</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "MYEC21"
  }
}

resource "aws_instance" "MYEC22" {
  ami           = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.WEBSG.id ]
  subnet_id = aws_subnet.MyPublicSN2.id
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  hostname ELB-EC2-2
  yum install httpd -y
  service httpd start
  chkconfig httpd on
  echo "<h1>CloudNet@ EC2-2 Web Server</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "MYEC22"
  }
}

# 탄력적 IP
resource "aws_eip" "MyEIP1" {
  instance = aws_instance.MYEC21.id
  domain   = "vpc"
}

resource "aws_eip_association" "MyEIP1Assoc" {
  instance_id   = aws_instance.MYEC21.id
  allocation_id = aws_eip.MyEIP1.id
}

resource "aws_eip" "MyEIP2" {
  instance = aws_instance.MYEC22.id
  domain   = "vpc"
}

resource "aws_eip_association" "MyEIP2Assoc" {
  instance_id   = aws_instance.MYEC22.id
  allocation_id = aws_eip.MyEIP2.id
}

# ALB 대상 그룹
resource "aws_lb_target_group" "ALBTargetGroup" {
  name     = "ALBTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.MyVPC.id
}

resource "aws_lb_target_group_attachment" "ALBTargetGroupAttacheEC21" {
  target_group_arn = aws_lb_target_group.ALBTargetGroup.arn
  target_id        = aws_instance.MYEC21.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ALBTargetGroupAttacheEC22" {
  target_group_arn = aws_lb_target_group.ALBTargetGroup.arn
  target_id        = aws_instance.MYEC22.id
  port             = 80
}

# ALB
resource "aws_lb" "ApplicationLoadBalancer" {
  name               = "ApplicationLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.WEBSG.id]
  subnets            = [aws_subnet.MyPublicSN1.id, aws_subnet.MyPublicSN2.id]
}

resource "aws_lb_listener" "ALBListener" {
  load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALBTargetGroup.arn
  }
}
