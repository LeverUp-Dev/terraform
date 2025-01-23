resource "aws_security_group" "allow_db" {
  name        = "allow_db"
  description = "Allow 3306/TCP inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "allow_db"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_db" {
  security_group_id = aws_security_group.allow_db.id
  cidr_ipv4         = data.aws_vpc.selected.cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_db" {
  security_group_id = aws_security_group.allow_db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_db_subnet_group" "my-db-sg" {
  name       = "my-db-sg"
  subnet_ids = data.aws_subnets.subnets.ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "myDB" {
  allocated_storage    = 10
  db_name              = "webdb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  db_subnet_group_name = aws_db_subnet_group.my-db-sg.name
  vpc_security_group_ids = [aws_security_group.allow_db.id]
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
