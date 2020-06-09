variable "identifier" {
  type        = string
  default     = "exposed"
  description = "Arbitrary label to tag resources with. Each resource will get this prefix in the tags."
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cidr_block_public_subnet_a" {
  type    = string
  default = "10.0.0.0/24"
}

variable "cidr_block_public_subnet_b" {
  type    = string
  default = "10.0.1.0/24"
}

variable "cidr_block_private_subnet_a" {
  type    = string
  default = "10.0.10.0/24"
}

variable "cidr_block_private_subnet_b" {
  type    = string
  default = "10.0.11.0/24"
}
