resource "aws_cloudwatch_log_group" "jwapp" {
  name = "/ecs/${local.full_name}"
}

