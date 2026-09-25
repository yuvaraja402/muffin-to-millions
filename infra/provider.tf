terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "microservice-to-millions-statefiles-bucket"
    key          = "infra/dev/terraform.tfstate"
    region       = "ca-central-1"
    use_lockfile = true
  }
}
# Configure the AWS Provider
provider "aws" {
  region = var.region
}

