variable "region" {
  type    = string
  default = "eu-west-1"
}

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