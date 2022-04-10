output "repository_url" {
  value = aws_ecr_repository.example_application_repository.repository_url
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.task_definition.arn
}
