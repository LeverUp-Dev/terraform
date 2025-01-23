variable "vpc_id" {
  description = "Id of VPC"
  type = string
}

variable "subnet_ids" {
  description = "Subnet ID list"
}

variable "db_username" {
  description = "Username for Database"
  type = string
}

variable "db_password" {
  description = "Password for Database"
  type = string
}