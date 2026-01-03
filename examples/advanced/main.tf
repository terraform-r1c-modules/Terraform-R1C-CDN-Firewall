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

  # Firewall settings configuration
  enable_firewall_settings = true
  firewall_settings = {
    action     = "allow"
    verify_sni = true
  }

  # Firewall rules
  firewall_rules = [
    {
      name        = "block-bad-countries"
      filter_expr = "ip.geoip.country in {\"CN\" \"RU\"}"
      action      = "deny"
      is_enabled  = true
      note        = "Block traffic from specific countries"
    },
    {
      name        = "allow-internal-ips"
      filter_expr = "ip.src in {192.168.0.0/16 10.0.0.0/8}"
      action      = "allow"
      is_enabled  = true
      note        = "Allow internal network traffic"
    },
    {
      name        = "challenge-suspicious"
      filter_expr = "http.request.uri.path contains \"/admin\""
      action      = "challenge"
      action_details = {
        challenge = {
          mode       = 2 # Javascript challenge
          ttl        = 3600
          https_only = true
        }
      }
      is_enabled = true
      note       = "Challenge requests to admin paths"
    },
    {
      name        = "bypass-static-assets"
      filter_expr = "http.request.uri.path matches \".*\\\\.(css|js|png|jpg|gif|ico)$\""
      action      = "bypass"
      action_details = {
        bypass = {
          waf       = true
          rlimit    = true
          challenge = false
        }
      }
      is_enabled = true
      note       = "Bypass security checks for static assets"
    }
  ]
}
