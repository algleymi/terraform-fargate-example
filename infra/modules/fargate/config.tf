terraform {
  required_providers {
    aws = "~> 2.53"
  }
}

provider "aws" {
  region = var.region
}