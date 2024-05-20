# Creates Spot Instances
resource "aws_spot_instance_request" "spot" {
  count                     = var.SPOT_INSTANCE_COUNT  

  ami                       = data.aws_ami.ami.id 
  instance_type             = var.SPOT_INSTANCE_TYPE
  subnet_id                 = var.INTERNAL ? element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index) : element(data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_IDS, count.index)
  vpc_security_group_ids    = [aws_security_group.allows_app.id]
  wait_for_fulfillment      = true   # aws waits for 10 mins to provision ( only in case if aws experiences resource limitation  )
  iam_instance_profile      = "b57-admin"
}

# Creates OD Instances
resource "aws_instance" "od" {
  count                     = var.OD_INSTANCE_COUNT  

  ami                       = data.aws_ami.ami.id 
  instance_type             = var.OD_INSTANCE_TYPE
  subnet_id                 = var.INTERNAL ? element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index) : element(data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_IDS, count.index)
  vpc_security_group_ids    = [aws_security_group.allows_app.id]
  iam_instance_profile      = "b57-admin"

}

# Name tag to the infra
resource "aws_ec2_tag" "app_tags" {
  count       = local.INSTANCE_COUNT
   
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "Name"
  value       = "roboshop-${var.ENV}-${var.COMPONENT}"
}


# Prometheus Monitoring Tag
resource "aws_ec2_tag" "monitor_tags" {
  count       = local.INSTANCE_COUNT
   
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "monitor"
  value       = "yes"
}
