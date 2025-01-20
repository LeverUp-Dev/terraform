data "aws_ami" "myubuntu2024" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "myec2" {
  ami           = data.aws_ami.myubuntu2024.id
  instance_type = var.indstance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = []
  key_name = var.keypair

  user_data = <<-EOF
#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y apache2
echo "<h1>WEB</h1>" > /var/www/html/index.html
EOF

  tags = var.ec2_tag
}
