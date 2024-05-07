resource "null_resource"  "app_deploy" {
    count   = local.INSTANCE_COUNT

    connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = element(local.INSTANCE_IPS, count.index)    # Use private ip only for the internal communcation.
  }

  provisioner "remote-exec" {
    inline = [
        "ansible-pull -U https://github.com/b57-clouddevops/ansible.git -e ENV=dev -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} roboshop-pull.yml"
    ]
  }
}