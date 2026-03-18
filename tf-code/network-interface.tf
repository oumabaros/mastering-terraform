resource "aws_network_interface" "frontend" {

  for_each = aws_subnet.frontend

  subnet_id = each.value.id
}

resource "aws_network_interface_sg_attachment" "frontend" {

  for_each = aws_instance.frontend

  security_group_id    = aws_security_group.frontend_lb.id
  network_interface_id = each.value.primary_network_interface_id

}
