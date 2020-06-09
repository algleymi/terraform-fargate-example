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

variable "host_headers" {
  type = list
  default = [
    "exposed.arnoschutijzer.io"
  ]
}
