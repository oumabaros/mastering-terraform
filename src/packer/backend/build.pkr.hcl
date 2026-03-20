
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
    #script = "sudo ./install-dotnet6-prereq.sh"
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository ppa:dotnet/backports",
      "sudo apt-get update"
      #"sudo apt install -y snapd",
      # "sudo apt-get install -y dotnet-sdk-10.0"
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
      "sudo groupadd myblazorapp-svc",
      "sudo useradd -g myblazorapp-svc myblazorapp-svc",
      "sudo mkdir -p /var/www/myblazorapp",
      "sudo chown -R myblazorapp-svc:myblazorapp-svc /var/www/myblazorapp"
    ]
  }

  # apt-install
  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "sudo apt-get install unzip -y"
    ]
  }

  provisioner "file" {
    source      = "./deployment.zip"
    destination = "/tmp/deployment.zip"
  }

  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "sudo unzip /tmp/deployment.zip -d /var/www/myblazorapp"
    ]
  }

  provisioner "file" {
    source      = "./files/myblazorapp.service"
    destination = "/tmp/myblazorapp.service"
  }

  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "sudo cp /tmp/myblazorapp.service /etc/systemd/system/myblazorapp.service"
    ]
  }

  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "sudo systemctl enable myblazorapp.service"
    ]
  }

  post-processor "docker-tag" {
    repository = "localstack-ec2/backend-ami"
    tags       = ["ami-000002"]
  }
}