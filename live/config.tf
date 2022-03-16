terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = "~> 4.0"
  }
}

provider "aws" {
  region = "eu-west-1"
}
