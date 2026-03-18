resource "aws_eip" "nat" {

  for_each = local.private_subnets

}

resource "aws_nat_gateway" "nat" {

  for_each = local.private_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.backend[each.key].id

  depends_on = [aws_internet_gateway.main]

}
