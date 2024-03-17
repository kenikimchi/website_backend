

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

