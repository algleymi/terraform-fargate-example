terraform {
  backend "s3" {
    bucket = "exposed.tf.state-bucket"
    key    = "test"
    region = "eu-west-1"
  }
}