resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env}-${var.project_name}-vpc"
  }
}

resource "aws_subnet" "main" {
  count             = length(var.subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.subnets_cidr, count.index)
  availability_zone = element(var.az, count.index)

  tags = {
    Name = "subnet-${count.index}"
  }
}

resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id = aws_vpc.main.id
  vpc_id      = data.aws_vpc.default.id
  auto_accept = true

  tags = {
    Name = "${var.env}-vpc-with-default-vpc"
  }
}

resource "aws_route" "main" {
  route_table_id            = aws_vpc.main.main_route_table_id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "default-vpc" {
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}