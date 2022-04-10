locals {
  container_name = "application"
  container_port = 80
}

resource "aws_ecr_repository" "example_application_repository" {
  name = "random-uuid"

  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.identifier}-random-uid"
  container_definitions    = module.app_container_definition.json_map_encoded_list
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
}

module "app_container_definition" {
  source           = "git@github.com:cloudposse/terraform-aws-ecs-container-definition"
  container_image  = "${aws_ecr_repository.example_application_repository.repository_url}:${var.image_tag}"
  container_name   = local.container_name
  container_cpu    = 256
  container_memory = 512
  essential        = true
  port_mappings = [
    {
      containerPort = local.container_port
      hostPort      = local.container_port
      protocol      = "tcp"
    }
  ]
}

resource "aws_iam_role" "task_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.task_execution_assume_role_policy.json

  inline_policy {
    name   = "application-iam-role-policy"
    policy = data.aws_iam_policy_document.task_execution_role_policy.json
  }
}

data "aws_iam_policy_document" "task_execution_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "task_execution_role_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      aws_ecr_repository.example_application_repository.arn
    ]
  }
}
