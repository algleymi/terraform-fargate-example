resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    // TODO: limit this to the loadbalancer!
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
  desired_count   = 1
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
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

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.identifier}-td"
  container_definitions    = file("./app.taskdefinition.json")
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
}

resource "aws_lb_target_group" "target_group" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}


resource "aws_lb_listener_rule" "exposed_role" {
  listener_arn = var.lb_http_listener_arn
  priority     = 101

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