terraform {
  required_version = ">= 1.5"

  required_providers {
    arvancloud = {
      source  = "terraform.arvancloud.ir/arvancloud/arvancloud"
      version = ">= 0.2.2"
    }
  }
}

provider "arvancloud" {
  api_key = var.arvancloud_api_key
}

module "cdn_firewall" {
  source = "../../"

  domain = var.domain

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
