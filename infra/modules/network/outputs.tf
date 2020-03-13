output "vpc_id" {
  value = aws_vpc.exposed.id
}

output "network_acl_id" {
  value = aws_network_acl.exposed
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}