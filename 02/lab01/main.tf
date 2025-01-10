# provider 설정
provider "aws" {
  region = "us-east-2"
}

# SG 생성
resource "aws_security_group" "allow_http_https" {
  name        = "allow_http_https"
  description = "Allow http_https inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.MyVPC.id

  tags = {
    Name = "allow_http_https"
  }
}

# SG rule 생성
resource "aws_vpc_security_group_ingress_rule" "allow_80_TCP" {
  security_group_id = aws_security_group.allow_http_https.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http_https.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 생성
resource "aws_instance" "WEB" {
  ami           = "ami-0d7ae6a161c5c4239"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.myPublicSub.id
  vpc_security_group_ids = [ aws_security_group.allow_http_https.id ]

  user_data_replace_on_change = true
  user_data = <<-EOF
  #!/bin/bash
  sudo yum install -y httpd
  sudo systemctl enable --now httpd
  echo "Hello World from" > /var/www/html/index.html
  EOF

  tags = {
    Name = "WEB"
  }
}

# VPC 생성
resource "aws_vpc" "MyVPC" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Internet Gateway 생성 및 VPC 연결
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.MyVPC.id

  tags = {
    Name = "myIGW"
  }
}

# VPC에 public subnet 생성
resource "aws_subnet" "myPublicSub" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "myPublicSub"
  }
}

# Routing Table 생성 및 Public Subnet에 연결
resource "aws_route_table" "myPubRT" {
  vpc_id = aws_vpc.MyVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }

  tags = {
    Name = "myPubRT"
  }
}

resource "aws_route_table_association" "myPubRouteAsso" {
  subnet_id      = aws_subnet.myPublicSub.id
  route_table_id = aws_route_table.myPubRT.id
}
