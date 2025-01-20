variable "indstance_type" {
  default = "t3.micro"
  description = "Instance Type"
  type = string
}

variable "ec2_tag" {
  default = {
    Name = "myec2"
  }
  description = "EC2 instance tag"
  type = map(string)
}

variable "subnet_id" {
  description = "subnet id"
  type = string
}
