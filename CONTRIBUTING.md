# Contributing to ArvanCloud CDN Firewall Terraform Module

First off, thank you for considering contributing to this project! 🎉

## Table of Contents

- [Contributing to ArvanCloud CDN Firewall Terraform Module](#contributing-to-arvancloud-cdn-firewall-terraform-module)
  - [Table of Contents](#table-of-contents)
  - [Code of Conduct](#code-of-conduct)
  - [Getting Started](#getting-started)
  - [Development Setup](#development-setup)
    - [Prerequisites](#prerequisites)
    - [Install Development Tools](#install-development-tools)
    - [Verify Setup](#verify-setup)
  - [How to Contribute](#how-to-contribute)
    - [Reporting Bugs](#reporting-bugs)
    - [Suggesting Features](#suggesting-features)
    - [Submitting Code Changes](#submitting-code-changes)
  - [Style Guidelines](#style-guidelines)
    - [Terraform Code Style](#terraform-code-style)
    - [File Organization](#file-organization)
    - [Naming Conventions](#naming-conventions)
  - [Commit Messages](#commit-messages)
    - [Types](#types)
    - [Examples](#examples)
  - [Pull Request Process](#pull-request-process)
  - [Testing](#testing)
    - [Local Testing](#local-testing)
    - [Integration Testing](#integration-testing)
  - [Documentation](#documentation)
  - [Questions?](#questions)

## Code of Conduct

This project and everyone participating in it is governed by our commitment to providing a welcoming and inclusive environment. Please be respectful and constructive in all interactions.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:

   ```bash
   git clone https://github.com/terraform-r1c-modules/terraform-r1c-cdn-firewall.git
   cd terraform-r1c-cdn-firewall
   ```

3. **Add the upstream remote**:

   ```bash
   git remote add upstream https://github.com/terraform-r1c-modules/terraform-r1c-cdn-firewall.git
   ```

4. **Create a branch** for your changes:

   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
- [TFLint](https://github.com/terraform-linters/tflint)
- [pre-commit](https://pre-commit.com/)

### Install Development Tools

```bash
# Install pre-commit hooks
pip install pre-commit
pre-commit install

# Install TFLint (Linux)
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
```

### Verify Setup

```bash
terraform version
tflint --version
pre-commit --version
```

## How to Contribute

### Reporting Bugs

- Use the [Bug Report](../../issues/new?template=bug_report.yml) template
- Include Terraform and provider versions
- Provide minimal reproduction steps
- Include error messages and logs

### Suggesting Features

- Use the [Feature Request](../../issues/new?template=feature_request.yml) template
- Explain the use case and benefits
- Consider backward compatibility

### Submitting Code Changes

1. Ensure your changes follow our [style guidelines](#style-guidelines)
2. Add or update tests as needed
3. Update documentation
4. Submit a pull request

## Style Guidelines

### Terraform Code Style

- Use `terraform fmt` to format all `.tf` files
- Use meaningful variable and resource names
- Add descriptions to all variables and outputs
- Use validation blocks for input validation
- Follow [HashiCorp's Terraform style conventions](https://developer.hashicorp.com/terraform/language/syntax/style)

```hcl
# Good
variable "pool_name" {
  description = "Name of the origin pool"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.pool_name))
    error_message = "Pool name must contain only lowercase letters, numbers, and hyphens."
  }
}

# Bad
variable "name" {
  type = string
}
```

### File Organization

```plaintext
.
├── main.tf           # Main resources
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Provider and Terraform version constraints
├── README.md         # Documentation
└── examples/
    ├── basic/        # Simple usage example
    └── advanced/     # Complex usage example
```

### Naming Conventions

- **Variables**: `snake_case`, descriptive names
- **Resources**: Use `this` for the primary resource
- **Locals**: `snake_case`
- **Outputs**: `snake_case`, match the resource attribute name when possible

## Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```plaintext
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

### Examples

```plaintext
feat(pool): add support for custom health checks

fix: correct region validation regex

docs: update README with new examples

chore: update GitHub Actions workflows
```

## Pull Request Process

1. **Update your branch** with the latest upstream changes:

   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run validation checks**:

   ```bash
   terraform fmt -check -recursive
   terraform init
   terraform validate
   tflint --recursive
   ```

3. **Push your changes** and create a pull request

4. **Fill out the PR template** completely

5. **Wait for review** - maintainers will review your PR and may request changes

6. **Address feedback** by pushing additional commits

7. Once approved, a maintainer will **merge your PR**

## Testing

### Local Testing

```bash
# Format check
terraform fmt -check -recursive

# Initialize
terraform init

# Validate
terraform validate

# Lint
tflint --recursive

# Test with examples
cd examples/basic
terraform init
terraform validate
terraform plan
```

### Integration Testing

For integration tests with a real ArvanCloud account:

1. Set up ArvanCloud API credentials
2. Use a test domain
3. Run `terraform apply` with the example configurations
4. Verify resources are created correctly
5. Run `terraform destroy` to clean up

## Documentation

- Update `README.md` for any changes to variables, outputs, or usage
- Add inline comments for complex logic
- Update examples to demonstrate new features
- Use proper Markdown formatting

## Questions?

If you have questions, feel free to:

- Open a [Question issue](../../issues/new?template=question.yml)
- Start a [Discussion](../../discussions)

Thank you for contributing! 🙏
