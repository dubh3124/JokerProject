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
      secrets = [
        {
          name = "CHOKIDAR_USEPOLLING"
          valueFrom = "${aws_secretsmanager_secret.jwsecrets.arn}:CHOKIDAR_USEPOLLING"
        },
        {
          name = "REACT_APP_JOKESTER_FRONTEND_URL"
          valueFrom = "${aws_secretsmanager_secret.jwsecrets.arn}:REACT_APP_JOKESTER_FRONTEND_URL"
        },
        {
          name = "REACT_APP_JOKESTER_CONTRACT"
          valueFrom = "${aws_secretsmanager_secret.jwsecrets.arn}:REACT_APP_JOKESTER_CONTRACT"
        },
        {
          name = "REACT_APP_JOKESTER_WEB3_STORAGE"
          valueFrom = "${aws_secretsmanager_secret.jwsecrets.arn}:REACT_APP_JOKESTER_WEB3_STORAGE"
        }
      ]
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