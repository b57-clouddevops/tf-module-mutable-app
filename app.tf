resource "null_resource"  "app_deploy" {
    count   = local.INSTANCE_COUNT

    triggers = {
        always_run = timestamp()            # This ensure that this provisioner would be triggering all the time
    }

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

# Provisioners are run-time by default : That means they only during the creation of the resources. 
# Once the infra is provisioned, from then it's not going to be executed.