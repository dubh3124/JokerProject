resource "aws_ecs_task_definition" "jwtaskdef" {
  family                = "taskdef-${local.full_name}"
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.jwapp-task-execution-role.arn
  task_role_arn = aws_iam_role.jwapp-task-role.arn
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  container_definitions = jsonencode([
    {
      name = "jwapp"
      essential = true
      image = aws_ecr_repository.ecr-jwapp.repository_url
      portMappings = [{
        containerPort = local.app_port
        hostport = local.app_port
      }]
      environment = [
        {
          name = "S3_UPLOAD_BUCKET"
          value = aws_s3_bucket.jwappupload.bucket
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region = var.region
          awslogs-group = aws_cloudwatch_log_group.jwapp.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}