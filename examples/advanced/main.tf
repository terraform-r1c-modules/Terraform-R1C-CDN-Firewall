# ArvanCloud CDN Firewall - Example Configuration

# Configure the ArvanCloud provider
provider "arvancloud" {
  api_key = var.arvancloud_api_key
}

# Example: Basic firewall configuration with rules
module "cdn_firewall" {
  source = "../../"

  domain = "example.ir"

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

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Variables for the example
variable "arvancloud_api_key" {
  description = "ArvanCloud API key"
  type        = string
  sensitive   = true
}

# Outputs
output "firewall_config" {
  description = "Firewall configuration summary"
  value       = module.cdn_firewall.firewall_settings
}

output "created_rules" {
  description = "Created firewall rules"
  value       = module.cdn_firewall.firewall_rules
}
