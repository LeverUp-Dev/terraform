variable "indstance_type" {
  default = "t2.micro"
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

variable "sg_ids" {
  description = "Security group IDs(list)"
  type = list
}

variable "keypair" {
  description = "EC2 Key Pair"
  type = string
}
