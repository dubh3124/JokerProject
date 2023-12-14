output "alb_url" {
  value = "http://${aws_alb.jwapp-lb.dns_name}"
}

output "ecs_cluster" {
  value = aws_ecs_cluster.jwcluster
}

output "ecs_service" {
  value = aws_ecs_service.app
}

output "ecr_repo" {
  value = aws_ecr_repository.ecr-jwapp
}