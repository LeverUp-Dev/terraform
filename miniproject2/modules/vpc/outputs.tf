output "vpc_id" {
  value = aws_vpc.myVPC.id
}

output "public_subnets_ids" {
  value = [aws_subnet.PubSub1.id, aws_subnet.PubSub2.id]
}

output "private_subnets_ids" {
  value = [aws_subnet.PriSub1.id, aws_subnet.PriSub2.id]
}

output "subnets_ids" {
  value = [aws_subnet.PubSub1.id, aws_subnet.PubSub2.id, aws_subnet.PriSub1.id, aws_subnet.PriSub2.id]
}
