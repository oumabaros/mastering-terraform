resource "aws_instance" "frontend" {

  for_each = aws_subnet.frontend

  ami           = data.aws_ami.frontend.id
  instance_type = var.frontend_instance_type
  key_name      = data.aws_key_pair.main.key_name
  #user_data     = data.cloudinit_config.frontend.rendered
  #monitoring = true

  network_interface {
    network_interface_id = aws_network_interface.frontend[each.key].id
    device_index         = 0
  }

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-frontend-instance"
    application = var.application_name
    environment = var.environment_name
  }
}

