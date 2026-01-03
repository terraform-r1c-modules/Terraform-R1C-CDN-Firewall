# -----------------------------------------------------------------------------
# Required Variables
# -----------------------------------------------------------------------------

variable "domain" {
  description = "The domain name to configure firewall settings for (e.g., example.ir)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\\.[a-zA-Z]{2,}$", var.domain)) || can(regex("^[a-zA-Z0-9-]+\\.[a-zA-Z0-9-]+\\.[a-zA-Z]{2,}$", var.domain))
    error_message = "The domain must be a valid hostname (e.g., example.ir or sub.example.ir)."
  }
}

# -----------------------------------------------------------------------------
# Firewall Settings Variables
# -----------------------------------------------------------------------------

variable "enable_firewall_settings" {
  description = "Whether to create the firewall settings resource"
  type        = bool
  default     = true
}

variable "firewall_settings" {
  description = "Domain firewall configuration settings"
  type = object({
    action = optional(string, "allow")
    action_details = optional(object({
      bypass = optional(object({
        waf       = bool
        challenge = bool
        rlimit    = bool
      }))
      challenge = optional(object({
        mode       = number # 1: Cookie, 2: Javascript, 3: Captcha
        ttl        = number
        https_only = bool
      }))
    }))
    verify_sni = optional(bool, true)
  })
  default = {
    action     = "allow"
    verify_sni = true
  }

  validation {
    condition     = contains(["allow", "deny", "bypass", "challenge"], var.firewall_settings.action)
    error_message = "action must be one of: allow, deny, bypass, challenge."
  }
}

# -----------------------------------------------------------------------------
# Firewall Rules Variables
# -----------------------------------------------------------------------------

variable "firewall_rules" {
  description = "List of firewall rules to create for the domain"
  type = list(object({
    name        = string
    filter_expr = string
    action      = string
    action_details = optional(object({
      bypass = optional(object({
        waf       = bool
        challenge = bool
        rlimit    = bool
      }))
      challenge = optional(object({
        mode       = number # 1: Cookie, 2: Javascript, 3: Captcha
        ttl        = number
        https_only = bool
      }))
    }))
    is_enabled = optional(bool, true)
    note       = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.firewall_rules : contains(["allow", "deny", "bypass", "challenge"], rule.action)
    ])
    error_message = "Each rule's action must be one of: allow, deny, bypass, challenge."
  }

  validation {
    condition = alltrue([
      for rule in var.firewall_rules : length(rule.filter_expr) >= 3 && length(rule.filter_expr) <= 5000
    ])
    error_message = "Each rule's filter_expr must be between 3 and 5000 characters."
  }
}
