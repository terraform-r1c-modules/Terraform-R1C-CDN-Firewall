# ArvanCloud CDN Firewall Module - Main Configuration

# -----------------------------------------------------------------------------
# Firewall Settings Resource
# -----------------------------------------------------------------------------
# Manages domain-level firewall configuration including default actions,
# SNI verification settings.

resource "arvancloud_cdn_domain_firewall" "this" {
  count = var.enable_firewall_settings ? 1 : 0

  domain     = var.domain
  action     = var.firewall_settings.action
  verify_sni = var.firewall_settings.verify_sni

  action_details = {
    bypass = var.firewall_settings.action == "bypass" ? {
      waf       = var.firewall_settings.action_details.bypass.waf
      challenge = var.firewall_settings.action_details.bypass.challenge
      rlimit    = var.firewall_settings.action_details.bypass.rlimit
    } : null

    challenge = var.firewall_settings.action == "challenge" ? {
      mode       = var.firewall_settings.action_details.challenge.mode
      ttl        = var.firewall_settings.action_details.challenge.ttl
      https_only = var.firewall_settings.action_details.challenge.https_only
    } : null
  }
}

# -----------------------------------------------------------------------------
# Firewall Rules Resources
# -----------------------------------------------------------------------------
# Creates individual firewall rules with filter expressions, actions, and
# priority settings for granular traffic control.

resource "arvancloud_cdn_domain_firewall_rule" "this" {
  for_each = { for rule in var.firewall_rules : rule.name => rule }

  domain      = var.domain
  name        = each.value.name
  filter_expr = each.value.filter_expr
  action      = each.value.action
  is_enabled  = each.value.is_enabled
  note        = each.value.note

  action_details = {
    bypass = each.value.action == "bypass" && each.value.action_details != null ? {
      waf       = each.value.action_details.bypass.waf
      challenge = each.value.action_details.bypass.challenge
      rlimit    = each.value.action_details.bypass.rlimit
    } : null

    challenge = each.value.action == "challenge" && each.value.action_details != null ? {
      mode       = each.value.action_details.challenge.mode
      ttl        = each.value.action_details.challenge.ttl
      https_only = each.value.action_details.challenge.https_only
    } : null
  }

  depends_on = [arvancloud_cdn_domain_firewall.this]
}
