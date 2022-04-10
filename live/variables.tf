# This value can be injected when running `terraform apply -var "image-tag=tag-here"`.
# This is especially useful when using immutable docker tags.
variable "image_tag" {
  type = string
}
