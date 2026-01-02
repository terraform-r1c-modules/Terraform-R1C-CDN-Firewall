# ArvanCloud CDN Firewall Module - Main Configuration

# -----------------------------------------------------------------------------
# Firewall Settings Resource
# -----------------------------------------------------------------------------
# Manages domain-level firewall configuration including default actions,
# SNI verification, and global whitelist/firewall skip options.

resource "arvancloud_cdn_firewall" "this" {
  count = var.enable_firewall_settings ? 1 : 0

  domain = var.domain

  default_action         = var.firewall_settings.default_action
  default_action_details = var.firewall_settings.default_action_details
  verify_sni             = var.firewall_settings.verify_sni
  skip_global_whitelist  = var.firewall_settings.skip_global_whitelist
  skip_global_firewall   = var.firewall_settings.skip_global_firewall
}

# -----------------------------------------------------------------------------
# Firewall Rules Resources
# -----------------------------------------------------------------------------
# Creates individual firewall rules with filter expressions, actions, and 
# priority settings for granular traffic control.

resource "arvancloud_cdn_firewall_rule" "this" {
  for_each = { for rule in var.firewall_rules : rule.name => rule }

  domain = var.domain

  name           = each.value.name
  filter_expr    = each.value.filter_expr
  action         = each.value.action
  action_details = each.value.action_details
  priority       = each.value.priority
  is_enabled     = each.value.is_enabled
  note           = each.value.note

  depends_on = [arvancloud_cdn_firewall.this]
}
