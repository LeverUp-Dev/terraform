terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "bucket-2001-1101"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}

# MySQL DB Instance 설정
resource "aws_db_instance" "myDBInstance" {
  identifier_prefix   = "my-"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true

  db_name = "myDB"

  # DB 접속시 사용자 이름: admin
  username = var.dbuser
  # DB 접속시 사용자 암호: password
  password = var.dbpassword
}
