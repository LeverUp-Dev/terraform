output "web_url" {
  value = "http://${module.my_alb.alb_dns_name}"
}

output "db_address" {
  value = module.my_db.db_address
}
