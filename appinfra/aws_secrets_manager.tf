resource "aws_secretsmanager_secret" "jwsecrets" {
  name = "secrets-${local.full_name}"
}
