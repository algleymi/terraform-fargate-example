resource aws_lb "lb" {
  name               = "${var.identifier}-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.lb_subnets

  tags = {
    Environment = var.identifier
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.identifier}-public-lb"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "any HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.identifier}-public-lb"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "400"
    }
  }
}

resource "aws_lb_target_group" "target_group" {
  depends_on = [
    aws_lb.lb
  ]
  deregistration_delay = 5

  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener_rule" "exposed_listener_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  # TODO: figure out of there's a more elegant way in adding listener rules to a LB
  priority = 101

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