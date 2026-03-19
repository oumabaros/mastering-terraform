
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

  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "apt-get update -y",
      "apt-get install -y sudo",
      "sudo apt-get install -y apt-utils",
      "sudo apt-get install -y wget",
      "sudo apt-get install -y curl",
      "sudo apt-get install -y systemd",
      "sudo cp /tmp/dotnet.pref /etc/apt/preferences.d/dotnet.pref"
    ]
  }

  # install dotnet pre-reqs
  provisioner "shell" {
    #execute_command = local.execute_command
    #script          = "./scripts/install-dotnet6-prereq.sh"
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository ppa:dotnet/backports",
      "sudo apt-get update"

    ]
  }

  # install dotnet6
  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "sudo apt-get install dotnet-sdk-8.0 -y"
    ]
  }

  # setup svc user
  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "groupadd myblazorapp-svc",
      "useradd -g myblazorapp-svc myblazorapp-svc",
      "mkdir -p /var/www/myblazorapp",
      "chown -R myblazorapp-svc:myblazorapp-svc /var/www/myblazorapp"
    ]
  }

  # apt-install
  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "apt-get install unzip -y"
    ]
  }

  provisioner "file" {
    source      = "./deployment.zip"
    destination = "/tmp/deployment.zip"
  }

  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "unzip /tmp/deployment.zip -d /var/www/myblazorapp"
    ]
  }

  provisioner "file" {
    source      = "./files/myblazorapp.service"
    destination = "/tmp/myblazorapp.service"
  }

  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "cp /tmp/myblazorapp.service /etc/systemd/system/myblazorapp.service"
    ]
  }

  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "systemctl enable myblazorapp.service"
    ]
  }

  post-processor "docker-tag" {
    repository = "localstack-ec2/frontend-ami"
    tags       = ["ami-000001"]
  }
}