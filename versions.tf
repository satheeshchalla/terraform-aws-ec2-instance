# Terraform module requirements

# If you use any frameworks like terraspace to build the projects using this terraform module,
# the version constraints will be managed at the project level by terraspace.

terraform {
  required_version = ">= 1.2.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.23.0"
    }
  }
}

provider "aws" {
  region = var.region
}