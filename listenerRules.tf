# Generates A Random Number 
resource "random_integer" "priority" {
  min = 100
  max = 500
}


#  private Listener Rule
resource "aws_lb_listener_rule" "prv_app_rule" {
  count        = var.INTERNAL  ? 1 : 0 
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN[0]
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTEDZONE_NAME}"]
    }
  }
}

#  public Listener Rule
resource "aws_lb_listener_rule" "pub_app_rule" {
  count        = var.INTERNAL  ? 0 : 1 
  listener_arn = data.terraform_remote_state.alb.outputs.PUBLIC_LISTENER_ARN[0]
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PUBLIC_HOSTEDZONE_NAME}"]
    }
  }
}