variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
}

variable "application_name" {
  type    = string
  default = "app"
}

variable "environment_name" {
  type    = string
  default = "dev"
}

variable "cidr_split_bits" {
  type    = number
  default = 8
}

variable "frontend_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "backend_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "frontend_image_name" {
  type = string
}

variable "backend_image_name" {
  type = string
}

variable "domain_name" {
  type = string
}
