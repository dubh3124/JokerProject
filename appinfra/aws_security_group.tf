resource "aws_security_group" "http" {
  name        = "http"
  description = "HTTP traffic"
  vpc_id      = data.terraform_remote_state.basnetwork.outputs.vpcid

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "egress_all" {
  name        = "egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = data.terraform_remote_state.basnetwork.outputs.vpcid

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_app" {
  name        = "ingress-jwappbackend-${local.full_name}"
  description = "Allow ingress to app"
  vpc_id      = data.terraform_remote_state.basnetwork.outputs.vpcid

  ingress {
    from_port   = local.app_port
    to_port     = local.app_port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}