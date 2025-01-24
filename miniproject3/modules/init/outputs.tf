output "ecs_cluster_name" {
  value = aws_ecs_cluster.cicdCluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.cicdService.name
}
