output "myalb_dns_name" {
  value = "http://${aws_lb.myALB.dns_name}/index.html"
  description = "WEB DNS name of load balancer"
}