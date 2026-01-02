# Terraform ArvanCloud CDN Firewall Module

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4?logo=terraform)
![Version](https://img.shields.io/github/v/release/terraform-r1c-modules/terraform-r1c-cdn-firewall?logo=github&color=red&label=Version)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

Terraform module to manage ArvanCloud CDN DNS records with support for all record types.

## Requirements

| Name                                                                             | Version  |
| -------------------------------------------------------------------------------- | -------- |
| [terraform](https://developer.hashicorp.com/terraform)                           | >= 1.5   |
| [arvancloud](https://git.arvancloud.ir/arvancloud/terraform-provider-arvancloud) | >= 0.2.2 |

## Usage

### Basic Usage

```hcl
module "cdn_firewall" {
  source  = "git@github.com:terraform-r1c-modules/Terraform-R1C-CDN-Firewall.git?ref=main"

  domain = "example.ir"

  firewall_settings = {
    default_action = "allow"
    verify_sni     = true
  }

  firewall_rules = [
    {
      name        = "block-bad-ips"
      filter_expr = "ip.src in {1.2.3.4 5.6.7.8}"
      action      = "deny"
      is_enabled  = true
    }
  ]
}
```

### Advanced Usage with Multiple Rules

```hcl
module "cdn_firewall" {
  source  = "git@github.com:terraform-r1c-modules/Terraform-R1C-CDN-Firewall.git?ref=main"

  domain = "example.ir"

  firewall_settings = {
    default_action        = "allow"
    verify_sni            = true
    skip_global_whitelist = false
    skip_global_firewall  = false
  }

  firewall_rules = [
    # Block traffic from specific countries
    {
      name        = "geo-block"
      filter_expr = "ip.geoip.country in {\"CN\" \"RU\"}"
      action      = "deny"
      priority    = 1
      is_enabled  = true
      note        = "Block high-risk countries"
    },
    # Challenge admin access
    {
      name        = "protect-admin"
      filter_expr = "http.request.uri.path contains \"/admin\""
      action      = "challenge"
      action_details = {
        mode       = 3  # Captcha
        ttl        = 3600
        https_only = true
      }
      priority   = 2
      is_enabled = true
    },
    # Bypass checks for static assets
    {
      name        = "bypass-static"
      filter_expr = "http.request.uri.path matches \".*\\.(css|js|png|jpg)$\""
      action      = "bypass"
      action_details = {
        waf       = true
        rlimit    = true
        challenge = false
      }
      priority   = 3
      is_enabled = true
    }
  ]
}
```

## Inputs

| Name                       | Description                                        | Type           | Default   | Required |
| -------------------------- | -------------------------------------------------- | -------------- | --------- | :------: |
| `domain`                   | The domain name to configure firewall settings for | `string`       | n/a       |   Yes    |
| `enable_firewall_settings` | Whether to create the firewall settings resource   | `bool`         | `true`    |    No    |
| `firewall_settings`        | Domain firewall configuration settings             | `object`       | See below |    No    |
| `firewall_rules`           | List of firewall rules to create                   | `list(object)` | `[]`      |    No    |
| `tags`                     | A map of tags to add to resources                  | `map(string)`  | `{}`      |    No    |

### firewall_settings Object

| Attribute                | Description                           | Type     | Default   |
| ------------------------ | ------------------------------------- | -------- | --------- |
| `default_action`         | Default action for unmatched requests | `string` | `"allow"` |
| `default_action_details` | Details for bypass/challenge actions  | `object` | `null`    |
| `verify_sni`             | Verify SNI matches hostname           | `bool`   | `true`    |
| `skip_global_whitelist`  | Skip global whitelist for domain      | `bool`   | `false`   |
| `skip_global_firewall`   | Skip global firewall for domain       | `bool`   | `false`   |

### firewall_rules Object

| Attribute        | Description                                     | Type     | Required |
| ---------------- | ----------------------------------------------- | -------- | :------: |
| `name`           | Rule name                                       | `string` |   Yes    |
| `filter_expr`    | Wireshark-like filter expression (3-5000 chars) | `string` |   Yes    |
| `action`         | Rule action: allow, deny, bypass, challenge     | `string` |   Yes    |
| `action_details` | Details for bypass/challenge actions            | `object` |    No    |
| `priority`       | Rule priority (lower = higher priority)         | `number` |    No    |
| `is_enabled`     | Whether the rule is enabled                     | `bool`   |    No    |
| `note`           | Optional note/description                       | `string` |    No    |

### action_details Object (for bypass)

| Attribute   | Description          | Type   | Default |
| ----------- | -------------------- | ------ | ------- |
| `rlimit`    | Bypass rate limiting | `bool` | `false` |
| `challenge` | Bypass challenge     | `bool` | `false` |
| `waf`       | Bypass WAF           | `bool` | `false` |

### action_details Object (for challenge)

| Attribute    | Description                                       | Type     | Default |
| ------------ | ------------------------------------------------- | -------- | ------- |
| `mode`       | Challenge mode: 1=Cookie, 2=JavaScript, 3=Captcha | `number` | n/a     |
| `ttl`        | Time-to-live in seconds (10-31536000)             | `number` | n/a     |
| `https_only` | Require HTTPS for challenge                       | `bool`   | `false` |

## Outputs

| Name                   | Description                                             |
| ---------------------- | ------------------------------------------------------- |
| `domain`               | The domain name for which firewall is configured        |
| `firewall_settings`    | The firewall settings configuration                     |
| `firewall_rules`       | Map of created firewall rules with their configurations |
| `firewall_rule_ids`    | List of all firewall rule IDs                           |
| `firewall_rules_count` | Total number of firewall rules created                  |

## Filter Expression Examples

The `filter_expr` uses Wireshark-like syntax. Here are some examples:

```text
# Block specific IP addresses
ip.src in {1.2.3.4 5.6.7.8}

# Block by country
ip.geoip.country in {"CN" "RU" "KP"}

# Allow specific paths
http.request.uri.path starts with "/api"

# Block requests without SSL
not ssl

# Complex expression
ip.geoip.country in {"IR" "TH" "US"} and ssl

# Match URI patterns
http.request.uri.path matches ".*\.(php|asp|aspx)$"

# Block by User-Agent
http.user_agent contains "bot"
```

## License

Apache 2.0 Licensed. See [LICENSE](LICENSE) for full details
