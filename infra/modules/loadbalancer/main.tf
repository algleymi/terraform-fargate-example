resource aws_lb "lb" {
  name               = "${var.identifier}-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.lb_subnets

  tags = {
    Environment = "${var.identifier}"
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
