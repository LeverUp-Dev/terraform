resource "aws_vpc" "myVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true

  tags = {
    Name = "myVPC"
  }
}

resource "aws_subnet" "PubSub1" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.101.0/24"

  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = true

  tags = {
    Name = "PubSub1"
  }
}

resource "aws_subnet" "PubSub2" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.102.0/24"

  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = true

  tags = {
    Name = "PubSub2"
  }
}

resource "aws_subnet" "PriSub1" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "PriSub1"
  }
}

resource "aws_subnet" "PriSub2" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "PriSub2"
  }
}

resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "myIGW"
  }
}

resource "aws_route_table" "PubSubRT" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }

  tags = {
    Name = "PubSubRT"
  }
}

resource "aws_route_table_association" "PubSubRT1_ass" {
  subnet_id      = aws_subnet.PubSub1.id
  route_table_id = aws_route_table.PubSubRT.id
}

resource "aws_route_table_association" "PubSubRT2_ass" {
  subnet_id      = aws_subnet.PubSub2.id
  route_table_id = aws_route_table.PubSubRT.id
}

# private route table 생성
resource "aws_route_table" "PriSubRT" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "PriSubRT"
  }
}

resource "aws_route_table_association" "PriSubRT1_ass" {
  subnet_id      = aws_subnet.PriSub1.id
  route_table_id = aws_route_table.PriSubRT.id
}

resource "aws_route_table_association" "PriSubRT2_ass" {
  subnet_id      = aws_subnet.PriSub2.id
  route_table_id = aws_route_table.PriSubRT.id
}

