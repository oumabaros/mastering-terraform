locals {
  timestamp       = regex_replace(timestamp(), "[- TZ:]", "")
  execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
}

variable "ami_prefix" {
  type    = string
  default = "packer-linux-docker"
}

packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  #image = "ubuntu:jammy"
  image  = "jrei/systemd-ubuntu:latest"
  commit = true
}

build {
  name = "ami-packer"
  sources = [
    "source.docker.ubuntu"
  ]
  provisioner "shell" {
    inline = ["mkdir -p /tmp/files"]
  }
  provisioner "file" {
    source      = "${path.root}/files/"
    destination = "/tmp/files/"
  }

  provisioner "shell" {
    #execute_command = local.execute_command
    inline = [
      "apt-get update -y",
      "apt-get install -y sudo",
      "sudo apt-get install -y wget",
      "sudo apt-get install -y apt-utils",
      "sudo apt-get install -y curl",
      "sudo apt-get install -y libterm-readline-gnu-perl",
      "sudo apt-get install -y systemd",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo cp /tmp/files/dotnet.pref /etc/apt/preferences.d/dotnet.pref",
      "sudo chown root:root /etc/apt/preferences.d/dotnet.pref",
      "sudo chmod 644 /etc/apt/preferences.d/dotnet.pref"
    ]
  }
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository ppa:dotnet/backports",
      "sudo apt-get update",
      "sudo apt install -y snapd",
      "sudo apt-get install -y dotnet-sdk-10.0"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo groupadd fleet-portal-svc",
      "sudo useradd -g fleet-portal-svc fleet-portal-svc",
      "sudo mkdir -p /var/www/fleet-portal",
      "sudo chown -R fleet-portal-svc:fleet-portal-svc /var/www/fleet-portal"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo cp /tmp/files/fleet-portal-svc.service /etc/systemd/system/fleet-portal-svc.service",
      "systemctl enable fleet-portal-svc.service"
    ]
  }
  # provisioner "shell" {
  #   scripts = ["/tmp/files/dotnet-install.sh --channel 6.0"]
  # }

  post-processor "manifest" {
    output = "ami_manifest.json"
  }

  post-processor "docker-tag" {
    repository = "localstack-ec2/ubuntu-focal-ami"
    tags       = ["ami-000001"]
  }
}