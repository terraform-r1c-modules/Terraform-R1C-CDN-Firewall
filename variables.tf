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
    default_action = optional(string, "allow")
    default_action_details = optional(object({
      # Bypass action options
      rlimit    = optional(bool, false)
      challenge = optional(bool, false)
      waf       = optional(bool, false)
      # Challenge action options
      mode       = optional(number) # 1: Cookie, 2: Javascript, 3: Captcha
      ttl        = optional(number)
      https_only = optional(bool)
    }))
    verify_sni            = optional(bool, true)
    skip_global_whitelist = optional(bool, false)
    skip_global_firewall  = optional(bool, false)
  })
  default = {
    default_action        = "allow"
    verify_sni            = true
    skip_global_whitelist = false
    skip_global_firewall  = false
  }

  validation {
    condition     = contains(["allow", "deny", "drop", "bypass", "challenge"], var.firewall_settings.default_action)
    error_message = "default_action must be one of: allow, deny, drop, bypass, challenge."
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
      # Bypass action options
      rlimit    = optional(bool)
      challenge = optional(bool)
      waf       = optional(bool)
      # Challenge action options
      mode       = optional(number) # 1: Cookie, 2: Javascript, 3: Captcha
      ttl        = optional(number)
      https_only = optional(bool)
    }))
    priority   = optional(number)
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

# -----------------------------------------------------------------------------
# Common Tags Variable
# -----------------------------------------------------------------------------

variable "tags" {
  description = "A map of tags to add to all resources (if supported)"
  type        = map(string)
  default     = {}
}
