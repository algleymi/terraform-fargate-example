resource "aws_vpc" "exposed" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.application_name
  }
}

resource "aws_network_acl" "exposed" {
  vpc_id = aws_vpc.exposed.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = var.application_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet_a" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id     = aws_vpc.exposed.id
  cidr_block = var.cidr_block_public_subnet_a

  tags = {
    Name = "${var.application_name} public subnet A"
  }
}

resource "aws_subnet" "public_subnet_b" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id     = aws_vpc.exposed.id
  cidr_block = var.cidr_block_public_subnet_b

  tags = {
    Name = "${var.application_name} public subnet B"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.exposed.id

  tags = {
    Name = "${var.application_name} internet gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.exposed.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.application_name} public routetable"
  }
}

resource "aws_route_table_association" "public_subnet_a_route_table" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b_route_table" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_gateway_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "${var.application_name} NAT"
  }
}

resource "aws_subnet" "private_subnet_a" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id     = aws_vpc.exposed.id
  cidr_block = var.cidr_block_private_subnet_a

  tags = {
    Name = "${var.application_name} private subnet A"
  }
}

resource "aws_subnet" "private_subnet_b" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id     = aws_vpc.exposed.id
  cidr_block = var.cidr_block_private_subnet_b

  tags = {
    Name = "${var.application_name} private subnet B"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.exposed.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.application_name} private routetable"
  }
}

resource "aws_route_table_association" "private_subnet_a_route_table" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_b_route_table" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}