output "lb_id" {
  value = aws_lb.lb.id
}

output "lb_security_group" {
  value = aws_security_group.lb_sg.id
}

output "lb_http_listener_arn" {
  value = aws_lb_listener.http_listener.arn
}