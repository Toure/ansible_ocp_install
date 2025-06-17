# terraform/main.tf

# Specify the required Terraform version and provider sources for stability.
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1"
    }
  }
}

# Configure the AWS Provider using the region variable.
# Authentication is handled automatically via standard AWS credential methods
# (e.g., environment variables, ~/.aws/credentials, or IAM instance profile).
provider "aws" {
  region = var.aws_region
}