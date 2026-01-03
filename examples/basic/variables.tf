variable "arvancloud_api_key" {
  description = "ArvanCloud API key for authentication"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "The domain name for DNS records"
  type        = string
  default     = "example.ir"
}
