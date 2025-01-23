# basic code
# terraform {
#   required_version = ">= 1.0.0, < 2.0.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-2"
# }

# resource "aws_iam_user" "existing_user" {
#   # Make sure to update this to your own user name!
#   name = "yevgeniy.brikman"
# }

# edit code
# provider "aws" {
#   region = "us-east-2"
# }

# resource "aws_iam_user" "createuser" {
  
#   name = "neo"
# }

# Improvements code 1
# provider "aws" {
#   region = "us-east-2"
# }

# resource "aws_iam_user" "createuser" {
#   count = 3      # count.index => 0, 1, 2
#   name = "neo.${count.index}"
# }

# Improvements code 2 - used variables.tf
provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "createuser" {
  count = length(var.user_name)
  name = "neo.${var.user_name[count.index]}"
}
