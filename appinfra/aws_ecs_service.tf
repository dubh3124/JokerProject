resource "aws_ecs_service" "app" {
  name = "ecsservice-${local.full_name}"
  launch_type = "FARGATE"
  task_definition = aws_ecs_task_definition.jwtaskdef.arn
  desired_count = 2
  cluster = aws_ecs_cluster.jwcluster.id
  load_balancer {
    target_group_arn = aws_lb_target_group.jwapptg.arn
    container_name = "jwapp"
    container_port = local.app_port
  }
  network_configuration {
    assign_public_ip = false
    security_groups = [aws_security_group.egress_all.id, aws_security_group.http.id, aws_security_group.ingress_app.id]
    subnets = data.terraform_remote_state.basnetwork.outputs.private-subnets
  }
  depends_on = [aws_ecr_repository.ecr-jwapp]
}
