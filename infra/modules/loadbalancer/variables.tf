variable "identifier" {
  type    = string
  default = "exposed"
}

variable "lb_subnets" {
  type = list
}

variable "vpc_id" {
  type = string
}