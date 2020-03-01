resource "aws_vpc" "exposed" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "exposed"
  }
}

resource "aws_network_acl" "main" {
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

output "network_acl_id" {
  value = aws_network_acl.main
}