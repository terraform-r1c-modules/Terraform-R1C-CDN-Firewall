# ArvanCloud CDN Firewall Terraform Module

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4?logo=terraform)
![Version](https://img.shields.io/github/v/release/terraform-r1c-modules/terraform-r1c-cdn-firewall?logo=github&color=red&label=Version)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

Terraform module to manage ArvanCloud CDN Firewall resource.

## Requirements

| Name                                                                             | Version  |
| -------------------------------------------------------------------------------- | -------- |
| [terraform](https://developer.hashicorp.com/terraform)                           | >= 1.5   |
| [arvancloud](https://git.arvancloud.ir/arvancloud/terraform-provider-arvancloud) | >= 0.2.2 |

## Important Notes

> [!WARNING]
> **Import Required**: The main firewall resource cannot be created from scratch. The firewall settings already exist for your domain. You must **import** the existing resource before applying changes.
>
> ```bash
> terraform import "module.firewall.arvancloud_cdn_domain_firewall.this[0]" example.ir
> ```
>
> **No Deletion**: Due to API limitations, destroying this resource will remove it from Terraform state but will not delete the actual firewall settings.

## Usage

### Basic Usage

```hcl
module "cdn_firewall" {
  source  = "git@github.com:terraform-r1c-modules/Terraform-R1C-CDN-Firewall.git?ref=main"

  domain = "example.ir"

  firewall_settings = {
    action     = "allow"
    verify_sni = true
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
    action     = "allow"
    verify_sni = true
  }

  firewall_rules = [
    # Block traffic from specific countries
    {
      name        = "geo-block"
      filter_expr = "ip.geoip.country in {\"CN\" \"RU\"}"
      action      = "deny"
      is_enabled  = true
      note        = "Block high-risk countries"
    },
    # Challenge admin access
    {
      name        = "protect-admin"
      filter_expr = "http.request.uri.path contains \"/admin\""
      action      = "challenge"
      action_details = {
        challenge = {
          mode       = 3  # Captcha
          ttl        = 3600
          https_only = true
        }
      }
      is_enabled = true
    },
    # Bypass checks for static assets
    {
      name        = "bypass-static"
      filter_expr = "http.request.uri.path matches \".*\\.(css|js|png|jpg)$\""
      action      = "bypass"
      action_details = {
        bypass = {
          waf       = true
          rlimit    = true
          challenge = false
        }
      }
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

| Attribute        | Description                           | Type     | Default   |
| ---------------- | ------------------------------------- | -------- | --------- |
| `action`         | Default action for unmatched requests | `string` | `"allow"` |
| `action_details` | Details for bypass/challenge actions  | `object` | `null`    |
| `verify_sni`     | Verify SNI matches hostname           | `bool`   | `true`    |

### firewall_rules Object

| Attribute        | Description                                     | Type     | Required |
| ---------------- | ----------------------------------------------- | -------- | :------: |
| `name`           | Rule name                                       | `string` |   Yes    |
| `filter_expr`    | Wireshark-like filter expression (3-5000 chars) | `string` |   Yes    |
| `action`         | Rule action: allow, deny, bypass, challenge     | `string` |   Yes    |
| `action_details` | Details for bypass/challenge actions            | `object` |    No    |
| `is_enabled`     | Whether the rule is enabled                     | `bool`   |    No    |
| `note`           | Optional note/description                       | `string` |    No    |

### action_details Object

The `action_details` contains nested objects for `bypass` or `challenge` actions:

#### bypass (when action = "bypass")

| Attribute   | Description          | Type   | Required |
| ----------- | -------------------- | ------ | :------: |
| `rlimit`    | Bypass rate limiting | `bool` |   Yes    |
| `challenge` | Bypass challenge     | `bool` |   Yes    |
| `waf`       | Bypass WAF           | `bool` |   Yes    |

#### challenge (when action = "challenge")

| Attribute    | Description                                       | Type     | Required |
| ------------ | ------------------------------------------------- | -------- | :------: |
| `mode`       | Challenge mode: 1=Cookie, 2=JavaScript, 3=Captcha | `number` |   Yes    |
| `ttl`        | Time-to-live in seconds                           | `number` |   Yes    |
| `https_only` | Require HTTPS for challenge                       | `bool`   |   Yes    |

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
