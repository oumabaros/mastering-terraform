resource "aws_subnet" "frontend" {

  for_each = local.public_subnets

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-public-subnet"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_subnet" "backend" {

  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-private-subnet"
    application = var.application_name
    environment = var.environment_name
  }
}
