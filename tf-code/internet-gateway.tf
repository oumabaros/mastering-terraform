# Creating InternetGateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-internet-gateway"
    application = var.application_name
    environment = var.environment_name
  }
}
