resource "aws_lb_target_group" "jwapptg" {
  name        = "targetgroup-${local.full_name}"
  port        = local.app_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.basnetwork.outputs.vpcid
  deregistration_delay = 10

  health_check {
    enabled = true
    path    = "/"
  }
}

resource "aws_alb" "jwapp-lb" {
  name               = "lb-${local.full_name}"
  internal           = false
  load_balancer_type = "application"

  subnets = data.terraform_remote_state.basnetwork.outputs.public-subnets

  security_groups = [
    aws_security_group.http.id,
    aws_security_group.ingress_app.id,
    aws_security_group.egress_all.id,
  ]
}

resource "aws_alb_listener" "sun_app_http" {
  load_balancer_arn = aws_alb.jwapp-lb.arn
  port              = local.app_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jwapptg.arn
  }
}
