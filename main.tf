provider "aws" {
  region = var.aws.region
}

terraform {
  backend "s3" {
  }
}
