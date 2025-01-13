provider "aws" {
    region = "us-east-2"
}

# AMI 생성
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20241109"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# EC2 인스턴스를 위한 Security 그룹 생성
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "allow SSH inbound traffiv and all outbound"

  tags = {
    Name = "allow_ssh"
  }
}

# 시큐리티 그룹 인바운드 규칙
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# 시큐리티 그룹 아웃바운드 규칙
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# 인스턴스 생성
# - 키페어 생성
# - 시큐리티 그룹 지정
resource "aws_instance" "myEC2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name = "mykeypair2"
  security_groups = [ aws_security_group.allow_ssh.name ]

  tags = {
    Name = "myEC2-test"
  }
}

#아웃풋
output "amd_id" {
  value       = aws_instance.myEC2.ami
  description = "Ubuntu 24.04 LTS AMI ID"
}

output "vpc_id" {
  value = aws_security_group.allow_ssh.vpc_id
  description = "VPC ID"
}
