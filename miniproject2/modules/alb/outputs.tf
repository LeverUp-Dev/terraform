output "target_group_arn" {
  value = aws_lb_target_group.myLB_TG.arn
}

output "alb_dns_name" {
  value = aws_lb.myLB.dns_name
}
