variable "identifier" {
  type    = string
  default = "example"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the stack will be created."
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "subnets" {
  type = list(any)
}

variable "load_balancer_listener_arn" {
  type = string
}

variable "host_headers" {
  type = list(any)
  default = [
    "example.arnoschutijzer.io"
  ]
}
