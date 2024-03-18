# S3
variable "domain_name" {
  description = "Root domain of the website"
  type        = string
}

# CloudFront
variable "origin_access_type" {
  description = "Origin access type"
  type        = string
}

variable "root_object" {
  description = "The file for the root object such as index"
  type        = string
}

variable "site_aliases" {
  description = "Alternate site address aliases"
  type        = list(string)
}

variable "geo_restriction_locations" {
  description = "Locations allowed by CloudFront"
  type        = list(string)
}

variable "price_class" {
  description = "The price class of the CloudFront distribution"
  type        = string
}

# Route53
variable "private_zone" {
  description = "Certificate private zone or not"
  type        = bool
  default     = false
}