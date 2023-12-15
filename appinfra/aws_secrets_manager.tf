resource "aws_secretsmanager_secret" "jokester_contract" {
  name = "react_app_jokester_contract"
}

resource "aws_secretsmanager_secret" "jokester_frontend_url" {
  name = "react_app_jokester_frontend_url"
}

resource "aws_secretsmanager_secret" "jokester_web3_storage" {
  name = "react_app_jokester_web3_storage"
}

resource "aws_secretsmanager_secret" "chokidar_usepolling" {
  name = "chokidar_usepolling"
}