
build {
  # sources = [
  #   "source.amazon-ebs.vm"
  # ]
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "file" {
    source      = "./files/dotnet.pref"
    destination = "/tmp/dotnet.pref"
  }

  # provisioner "file" {
  #   source      = "./scripts/cron.sh"
  #   destination = "/tmp/cron.sh"
  # }

  provisioner "shell" {

    inline = [
      "apt-get update -y",
      "apt-get install -y sudo",
      "sudo apt-get install -y apt-utils",
      "sudo apt-get install -y wget",
      "sudo apt-get install -y curl",
      "sudo apt-get install -y systemd",
      "sudo apt install httpie -y",
      "sudo cp /tmp/dotnet.pref /etc/apt/preferences.d/dotnet.pref"
    ]
  }


  provisioner "shell" {

    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install cron -y",
      "sudo apt install lsof -y",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository ppa:dotnet/backports",
      "sudo apt-get update",
      "sudo apt install -y snapd",
      "sudo apt install acl -y",
      "sudo apt install systemd-sysv -y"

    ]
  }

  # provisioner "shell" {
  #   inline = [
  #     "sudo mkdir -p /usr/local/scripts",
  #     "sudo cp /tmp/cron.sh /usr/local/scripts/cron.sh",
  #     "sudo chmod +x /usr/local/scripts/cron.sh"

  #   ]
  # }


  provisioner "shell" {

    inline = [
      "sudo apt-get install dotnet-sdk-8.0 -y"
    ]
  }

  # setup svc user
  provisioner "shell" {

    inline = [
      "sudo groupadd myblazorapp-svc",
      "sudo useradd -g myblazorapp-svc myblazorapp-svc",
      "sudo mkdir -p /var/www/myblazorapp",
      "sudo chown -R myblazorapp-svc:myblazorapp-svc /var/www/myblazorapp",
      #"sudo setfacl -R -m u:myblazorapp-svc:rwx /var/www/myblazorapp",
      "sudo chmod -R 777 /var/www/myblazorapp"
    ]
  }


  provisioner "shell" {

    inline = [
      "sudo apt-get install unzip -y",
      "mkdir -p /tmp/deployment"
    ]
  }

  provisioner "file" {
    source      = "./deployment.zip"
    destination = "/tmp/deployment/deployment.zip"
  }

  provisioner "shell" {

    inline = [
      "unzip -o /tmp/deployment/deployment.zip -d /var/www/myblazorapp",
      "find /tmp/deployment -name 'deployment.zip' -type f -delete"

    ]
  }

  # provisioner "shell" {
  #   inline = [
  #     "/usr/local/scripts/cron.sh"
  #   ]
  # }

  provisioner "file" {
    source      = "./files/myblazorapp.service"
    destination = "/tmp/myblazorapp.service"
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/myblazorapp.service /etc/systemd/system/myblazorapp.service"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "systemctl enable myblazorapp.service"
    ]
  }

  post-processor "docker-tag" {
    repository = "localstack-ec2/backend-ami"
    tags       = ["ami-000002"]
  }
}