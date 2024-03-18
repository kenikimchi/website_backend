variable "domain_name" {
  description = "Root domain of the website"
  type        = string
}

variable "private_zone" {
  description = "Public or private zone"
  type        = bool
  default     = false
}

variable "s3_distribution_domain_name" {
  description = "Domain name of the s3 distribution"
  type        = string
}

variable "s3_distribution_hosted_zoned_id" {
  description = "Hosted zone id of the s3 distribution"
}