output "lb_id" {
  value = aws_lb.lb.id
}

output "lb_security_group" {
  value = aws_security_group.lb_sg.id
}