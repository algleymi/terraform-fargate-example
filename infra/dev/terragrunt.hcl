remote_state {
  backend = "s3"
  generate = {
    path      = "exposed.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "tf-state.exposed.dev"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "eu-west-1"
}
EOF
}