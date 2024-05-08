# Creates Target Group
resource "aws_lb_target_group" "app" {
  name     = "${var.COMPONENT}-${var.ENV}-tg"
  port     = var.APP_PORT
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID

  health_check {
    path                = "/health"         # Path to check for health (e.g., a health endpoint) 
    healthy_threshold   = 2                 # Minimum number of successful checks before marking healthy
    unhealthy_threshold = 2                 # Maximum number of failed checks before marking unhealthy
    timeout             = 4                 # Timeout in seconds for each health check attempt
    interval            = 5 
    enabled             = true 
  }
}

# Register the Backend Instance to the appropriate target group.check " 
resource "aws_lb_target_group_attachment" "attach_instances" {
  count            = local.INSTANCE_COUNT

  target_group_arn = aws_lb_target_group.app.arn
  target_id        = element(local.INSTANCE_IDS, count.index)
  port             = var.APP_PORT
}