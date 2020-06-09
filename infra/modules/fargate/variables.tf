variable "identifier" {
  type    = string
  default = "exposed"
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
  type = list
}

variable "target_group_arn" {
  type = string
}