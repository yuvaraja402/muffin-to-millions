# Project variables
variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "microservice-to-millions"
}

variable "region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "ca-central-1"
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "dev"
}

variable "tool" {
  description = "Name of tool used for infrastructure management"
  type        = string
  default     = "terraform"
}


# S3 variables
variable "s3_state_bucket" {
  description = "The name of the S3 bucket used to store Terraform state files"
  type        = string
  default     = "statefiles-bucket"
}

variable "s3_artifacts_bucket" {
  description = "The name of the S3 bucket used to store application's artifacts"
  type        = string
  default     = "artifacts-bucket"
}



# ECR variables