variable "vpc_id" {
  default = "10.0.0.0/16"
  description = "VPC cidr"
  type = string
}

variable "vpc_tag" {
  default = {
    Name = "myvpc"
  }
  description = "VPC tag"
  type = map(string)
}

variable "igw_tag" {
  default = {
    Name = "myigw"
  }
  description = "VPC tag"
  type = map(string)
}

variable "vpc_subnet" {
  default = "10.0.1.0/24"
  description = "VPC Public Subnet"
  type = string
}

variable "subnet_tag" {
  default = {
    Name = "mysubnet"
  }
  description = "public subnet tag"
  type = map(string)
}

variable "routetable_tag" {
  default = {
    Name = "mypubtable"
  }
  description = "public routing table tag"
  type = map(string)
}

variable "mysg_tag" {
  default = {
    Name = "mysg"
  }
  description = "sg tag"
  type = map(string)
}
