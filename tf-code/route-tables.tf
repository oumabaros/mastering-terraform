resource "aws_route_table" "frontend" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "frontend" {

  for_each = aws_subnet.frontend

  subnet_id      = each.value.id
  route_table_id = aws_route_table.frontend.id

}

resource "aws_route_table" "backend" {

  for_each = local.private_subnets

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }
}

resource "aws_route_table_association" "backend" {

  for_each = local.private_subnets

  subnet_id      = aws_subnet.backend[each.key].id
  route_table_id = aws_route_table.backend[each.key].id

}
