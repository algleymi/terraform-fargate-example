variable "identifier" {
  type    = string
  default = "example"
}

variable "lb_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "host_headers" {
  type = list(any)
  default = [
    "example.arnoschutijzer.io"
  ]
}
