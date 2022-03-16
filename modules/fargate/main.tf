locals {
  container_name   = "application"
  application_port = 80
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    // TODO: limit this to the loadbalancer
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.identifier}-ecs-security-group"
  }
}

resource "aws_lb_target_group" "target_group" {
  deregistration_delay = 1

  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.identifier}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.instance_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = local.container_name
    container_port   = 80
  }

  network_configuration {
    subnets = var.subnets
    security_groups = [
      aws_security_group.allow_tls.id
    ]
  }

  // ignore all changes to the task definition since
  // this needs to be triggered by the ECS deployment pipeline
  // or via the CLI through
  // aws ecs update-service --cluster example-cluster --service example-service \
  // --task-definition $(terraform output -json | jq -r ".task_definition_arn.value")
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.identifier}-cluster"
}

module "app_container_definition" {
  source           = "git@github.com:cloudposse/terraform-aws-ecs-container-definition"
  container_image  = "public.ecr.aws/skryv/placeholder:latest"
  container_name   = local.container_name
  container_cpu    = 256
  container_memory = 512
  essential        = true
  port_mappings = [
    {
      containerPort = local.application_port
      hostPort      = local.application_port
      protocol      = "tcp"
    }
  ]

  environment = [
    {
      name  = "PORT"
      value = local.application_port
    }
  ]
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.identifier}-td"
  container_definitions    = module.app_container_definition.json_map_encoded_list
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
}

resource "aws_lb_listener_rule" "example_listener_rule" {
  listener_arn = var.load_balancer_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = var.host_headers
    }
  }
}
