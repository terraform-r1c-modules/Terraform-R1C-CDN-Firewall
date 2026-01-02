# ArvanCloud CDN Firewall - Simple Example

provider "arvancloud" {
  api_key = var.arvancloud_api_key
}

module "cdn_firewall" {
  source = "../../"

  domain = "example.ir"

  # Simple firewall settings
  firewall_settings = {
    action     = "allow"
    verify_sni = true
  }

  # Single rule to block specific IPs
  firewall_rules = [
    {
      name        = "block-malicious-ips"
      filter_expr = "ip.src in {1.2.3.4 5.6.7.8}"
      action      = "deny"
      is_enabled  = true
    }
  ]
}

variable "arvancloud_api_key" {
  type      = string
  sensitive = true
}

output "domain" {
  value = module.cdn_firewall.domain
}
