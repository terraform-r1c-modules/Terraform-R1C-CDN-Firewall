output "firewall_config" {
  description = "Firewall configuration summary"
  value       = module.cdn_firewall.firewall_settings
}

output "created_rules" {
  description = "Created firewall rules"
  value       = module.cdn_firewall.firewall_rules
}
