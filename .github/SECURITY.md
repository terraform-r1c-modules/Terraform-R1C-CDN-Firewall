# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability within this project, please follow these steps:

### Do NOT

- Open a public GitHub issue
- Disclose the vulnerability publicly before it has been addressed

### Do

1. **Email us directly** at <hatamiarash7@gmail.com>
2. **Use GitHub's private vulnerability reporting** feature if available
3. **Include the following information:**
   - Type of vulnerability
   - Full paths of source file(s) related to the vulnerability
   - Location of the affected source code (tag/branch/commit or direct URL)
   - Step-by-step instructions to reproduce the issue
   - Proof-of-concept or exploit code (if possible)
   - Impact of the issue, including how an attacker might exploit it

### What to Expect

- **Acknowledgment**: We will acknowledge your email within 48 hours
- **Communication**: We will keep you informed of the progress towards a fix
- **Disclosure**: We will coordinate with you on the public disclosure date
- **Credit**: We will credit you in our security advisory (unless you prefer to remain anonymous)

## Security Best Practices

When using this Terraform module:

1. **Secure your Terraform state**: Use remote state with encryption enabled
2. **Use least privilege**: Grant minimal permissions to the ArvanCloud API key
3. **Rotate credentials**: Regularly rotate your API keys
4. **Review changes**: Always review Terraform plans before applying
5. **Version pinning**: Pin module versions in production environments

## Security Updates

Security updates will be released as patch versions. We recommend:

- Subscribing to repository releases to get notifications
- Regularly updating to the latest patch version
- Reviewing the CHANGELOG for security-related updates

## Contact

For security concerns, please contact: <hatamiarash7@gmail.com>
