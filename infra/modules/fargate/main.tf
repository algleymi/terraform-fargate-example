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

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.identifier}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.instance_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "exposed-app"
    container_port   = 80
  }

  network_configuration {
    subnets = var.subnets
    security_groups = [
      aws_security_group.allow_tls.id
    ]
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.identifier}-cluster"
}

module "app_container_definition" {
  source           = "git@github.com:cloudposse/terraform-aws-ecs-container-definition?ref=0.24.0"
  container_image  = "arnoschutijzer/exposed:latest"
  container_name   = "exposed-app"
  container_cpu    = 256
  container_memory = 512
  essential        = true
  port_mappings = [
    {
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }
  ]
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.identifier}-td"
  container_definitions    = "[${module.app_container_definition.json_map}]"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
}
