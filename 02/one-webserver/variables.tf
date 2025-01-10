variable "security_group_name" {
  #name = var.security_group_name
  description = "The name of the security group"
  type = string
  default = "allow_8080"
}

variable "server_port" {
  description = "the port server will use for HTTP request"
  type = number
  default = 8080
}