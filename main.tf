// Define the necesary providers for this terraform project. Provider HashiCorp in its version 4.36.1.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  required_version = "~> 1.0"
}

# Set up AWS provider. Use the variable aws_region from the variable file.
provider "aws" {
  region = var.aws_region
}