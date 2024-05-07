locals {
    INSTANCE_COUNT = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT
    INSTANCE_IDS   = concat(aws_spot_instance_request.spot.*.spot_instance_id , aws_instance.od.*.id)
    INSTANCE_IPS   = concat(aws_spot_instance_request.spot.*.private_ip , aws_instance.od.*.private_ip)
}