terraform {
  required_version = "1.6.5"
  required_providers {
    aws = "5.30.0"
  }
  backend "s3" {}
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project = var.project_alias
      environment = var.environment
    }
  }
}

data "terraform_remote_state" "basnetwork" {
  backend = "s3"
  config = {
    bucket = "buildatscale-terraform-state-files"
    key = "basnetwork.tfstate"
    region = var.region
  }
}