# Route53

provider "aws" {
  region = "us-east-1"
  alias  = "east"
}

resource "aws_acm_certificate" "root" {
  provider                  = aws.east
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "root" {
  name         = var.domain_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "dnsRecords" {
  for_each = {
    for dvo in aws_acm_certificate.root.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root.zone_id
}

resource "aws_route53_record" "primary" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.s3_distribution_domain_name
    zone_id                = var.s3_distribution_hosted_zoned_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.s3_distribution_domain_name
    zone_id                = var.s3_distribution_hosted_zoned_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate_validation" "root" {
  provider                = aws.east
  certificate_arn         = aws_acm_certificate.root.arn
  validation_record_fqdns = [for record in aws_route53_record.dnsRecords : record.fqdn]
}