# VPC 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_id
  instance_tenancy = "default"

  tags = var.vpc_tag
}

# 인터넷 게이트웨이 생성 및 연결
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = var.igw_tag
}

# public Subnet 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.vpc_subnet
  availability_zone = "ap-northeast-2a"
  tags = var.subnet_tag
}

# public Routing Table 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "mypubtable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = var.routetable_tag
}

# public Routing Table에 Default Route 설정
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.mypubtable.id
}

# sg
resource "aws_security_group" "mysg" {
  name        = "allow_web"
  description = "Allow HTTP/HTTPS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = var.mysg_tag
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = aws_vpc.myvpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = aws_vpc.myvpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
