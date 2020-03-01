resource "aws_vpc" "exposed" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "exposed"
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
    Name = "exposed"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.exposed.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public subnet A"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.exposed.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public subnet B"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.exposed.id

  tags = {
    Name = "exposed internet gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.exposed.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "exposed public routetable"
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
