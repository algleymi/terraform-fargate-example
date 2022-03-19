output "task_definition_arn" {
  value = aws_ecs_task_definition.task_definition.arn
}

output "container_name" {
  value = local.container_name
}

output "container_port" {
  value = local.container_port
}
