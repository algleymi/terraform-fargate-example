variable "identifier" {
  type    = string
  default = "exposed"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the stack will be created."
}

variable "lb_http_listener_arn" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "subnets" {
  type = list
}

variable "host_headers" {
  type = list
  default = [
    "exposed.arnoschutijzer.io"
  ]
}