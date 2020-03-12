remote_state {
  backend = "s3"
  generate = {
    path      = "exposed.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "tf-state.exposed.dev"

    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}