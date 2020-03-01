output "network_acl_id" {
  value = aws_network_acl.exposed
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}
