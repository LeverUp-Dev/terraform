output "public_ip" {
  value = aws_instance.web.public_ip
  description = "he public IP of the Instance"
}