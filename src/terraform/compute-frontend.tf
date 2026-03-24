resource "aws_instance" "frontend" {

  for_each = aws_subnet.frontend

  ami           = data.aws_ami.frontend.id
  instance_type = var.frontend_instance_type
  key_name      = data.aws_key_pair.main.key_name
  user_data     = <<-EOF
    #!/bin/bash
    su -
    /var/www/myblazorapp/FleetPortal
  EOF

  #filebase64("${path.module}/files/frontend.sh") #data.cloudinit_config.frontend.rendered
  #monitoring = true

  network_interface {
    network_interface_id = aws_network_interface.frontend[each.key].id
    device_index         = 0
  }

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-frontend-vm"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_eip" "frontend" {

  for_each = aws_instance.frontend

  instance = each.value.id

}

