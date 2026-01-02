# -----------------------------------------------------------------------------
# Firewall Settings Outputs
# -----------------------------------------------------------------------------

output "firewall_settings" {
  description = "The firewall settings configuration for the domain"
  value = var.enable_firewall_settings ? {
    domain                = var.domain
    is_enabled            = true
    default_action        = var.firewall_settings.default_action
    verify_sni            = var.firewall_settings.verify_sni
    skip_global_whitelist = var.firewall_settings.skip_global_whitelist
    skip_global_firewall  = var.firewall_settings.skip_global_firewall
  } : null
}

# -----------------------------------------------------------------------------
# Firewall Rules Outputs
# -----------------------------------------------------------------------------

output "firewall_rules" {
  description = "Map of all created firewall rules with their configurations"
  value = {
    for name, rule in arvancloud_cdn_firewall_rule.this : name => {
      id         = rule.id
      name       = rule.name
      action     = rule.action
      priority   = rule.priority
      is_enabled = rule.is_enabled
    }
  }
}

output "firewall_rule_ids" {
  description = "List of all firewall rule IDs"
  value       = [for rule in arvancloud_cdn_firewall_rule.this : rule.id]
}

output "firewall_rules_count" {
  description = "Total number of firewall rules created"
  value       = length(arvancloud_cdn_firewall_rule.this)
}

# -----------------------------------------------------------------------------
# Domain Output
# -----------------------------------------------------------------------------

output "domain" {
  description = "The domain name for which firewall is configured"
  value       = var.domain
}
