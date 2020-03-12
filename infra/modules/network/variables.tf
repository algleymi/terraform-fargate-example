// Generic variables used throughout all the resources.
// Any other variables required for the resources can be found in
// the same script where the resource is defined.
variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "identifier" {
  type        = string
  default     = "exposed"
  description = "Arbitrary label to tag resources with. Each resource will get this prefix in the tags."
}
