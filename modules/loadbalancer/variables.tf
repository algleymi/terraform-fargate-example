variable "identifier" {
  type    = string
  default = "example"
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
    "example.arnoschutijzer.io"
  ]
}
