# Kendrick Kim

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

# Modules
module "s3" {
  source = "./modules/s3"

  domain_name = var.domain_name
}