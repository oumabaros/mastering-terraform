resource "aws_instance" "backend" {

  for_each = aws_subnet.backend

  ami           = data.aws_ami.backend.id
  instance_type = var.backend_instance_type
  key_name      = data.aws_key_pair.main.key_name
  user_data     = <<-EOF
    #!/bin/bash
    su -
    /var/www/myblazorapp/FleetAPI
  EOF
  #filebase64("${path.module}/files/backend.sh") #data.cloudinit_config.backend.rendered
  #monitoring = true

  network_interface {
    network_interface_id = aws_network_interface.backend[each.key].id
    device_index         = 0
  }

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-backend-vm"
    application = var.application_name
    environment = var.environment_name
  }
}
