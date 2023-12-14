resource "aws_ecr_repository" "ecr-jwapp" {
  name                 = "jokesterpool-${local.full_name}"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }


  # This bootstraps the initial docker image the ECS Service needs to pull
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = "../JokesterPool-frontend"
    command = "./build.sh"
    environment = {
      AWS_ACCOUNT = data.aws_caller_identity.current.id
      AWS_REGION =  var.region
      APP_NAME = aws_ecr_repository.ecr-jwapp.name
    }

  }
}
