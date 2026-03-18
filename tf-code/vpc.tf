resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-vpc-network"
    application = var.application_name
    environment = var.environment_name
  }
}
