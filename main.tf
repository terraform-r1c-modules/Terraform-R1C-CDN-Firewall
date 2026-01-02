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

  action_details {
    dynamic "bypass" {
      for_each = var.firewall_settings.action == "bypass" ? [var.firewall_settings.action_details.bypass] : []
      content {
        waf       = bypass.value.waf
        challenge = bypass.value.challenge
        rlimit    = bypass.value.rlimit
      }
    }

    dynamic "challenge" {
      for_each = var.firewall_settings.action == "challenge" ? [var.firewall_settings.action_details.challenge] : []
      content {
        mode       = challenge.value.mode
        ttl        = challenge.value.ttl
        https_only = challenge.value.https_only
      }
    }
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

  action_details {
    dynamic "bypass" {
      for_each = each.value.action == "bypass" && each.value.action_details != null ? [each.value.action_details.bypass] : []
      content {
        waf       = bypass.value.waf
        challenge = bypass.value.challenge
        rlimit    = bypass.value.rlimit
      }
    }

    dynamic "challenge" {
      for_each = each.value.action == "challenge" && each.value.action_details != null ? [each.value.action_details.challenge] : []
      content {
        mode       = challenge.value.mode
        ttl        = challenge.value.ttl
        https_only = challenge.value.https_only
      }
    }
  }

  depends_on = [arvancloud_cdn_domain_firewall.this]
}
