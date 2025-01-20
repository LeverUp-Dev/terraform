output "myvpc_id" {
  value = aws_vpc.myvpc.id
  description = "VPC ID"
}

output "mysubnet_id" {
  value = aws_subnet.mysubnet.id
  description = "subnet id"
}

output "sg_id" {
  value = aws_security_group.mysg.id
}
