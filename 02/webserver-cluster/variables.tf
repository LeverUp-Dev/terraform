variable "region" {
  default = "us-east-2"
  description = "Default Region"
  type = string
}

variable "web_port" {
  default = 80
  type = number
}

variable "amazon" {
  default = "137112412989"
  type = string
}

variable "min_instance" {
  default = 2
  type = number
}

variable "max_instance" {
  default = 10
  type = number
}
