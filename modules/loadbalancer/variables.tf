variable "identifier" {
  type = string
}

variable "lb_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}
