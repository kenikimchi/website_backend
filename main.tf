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

module "cloudfront" {
  source = "./modules/cloudfront"

  site_aliases              = var.site_aliases
  price_class               = var.price_class
  origin_access_type        = var.origin_access_type
  geo_restriction_locations = var.geo_restriction_locations
  root_object               = var.root_object
  www_domain_name           = module.s3.www_domain_name
  root_certificate_arn      = module.route53.root_certificate_arn
}

module "route53" {
  source = "./modules/route53"

  domain_name                     = var.domain_name
  private_zone                    = false
  s3_distribution_domain_name     = module.cloudfront.s3_distribution_domain_name
  s3_distribution_hosted_zoned_id = module.cloudfront.s3_distribution_hosted_zoned_id
}