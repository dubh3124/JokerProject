resource "aws_iam_role" "jwapp-task-execution-role" {
  name               = "${local.full_name}-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "jwapp-task-role" {
  name               = "${local.full_name}-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "s3access" {
  role   = aws_iam_role.jwapp-task-role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Sid": "bucketaccess",
      "Effect": "Allow",
      "Action": [
        "s3:*",
      ],
      "Resource": [
        aws_s3_bucket.jwappupload.arn,
        "${aws_s3_bucket.jwappupload.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy" "secretmanageraccess" {
  role       = aws_iam_role.jwapp-task-execution-role.name
  policy     = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "SecretManagerAccess",
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource": [
          aws_secretsmanager_secret.jwsecrets.arn
        ]
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.jwapp-task-execution-role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}