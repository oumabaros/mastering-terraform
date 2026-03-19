packer {
  # required_plugins {
  #   amazon = {
  #     source  = "github.com/hashicorp/amazon"
  #     version = "~> 1.2.6"
  #   }
  # }
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}