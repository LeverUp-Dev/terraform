variable "vpc_id" {
  description = "VPC id"
}

variable "db_address" {
  description = "DB IP address"
}

variable "db_username" {
  description = "DB username"
}

variable "db_password" {
  description = "DB password"
}

variable "target_group_arns" {
  description = "Target Group arn list"
}

variable "vpc_zone_identifier" {
  description = "VPC Zone Idenf"
}
