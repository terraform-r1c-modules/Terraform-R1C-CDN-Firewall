# TFLint configuration
# https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/config.md

config {
  # Enable module inspection
  call_module_type = "local"

  # Force to return an error when issues were detected
  force = false
}

# Terraform plugin for general best practices
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Naming convention rules
rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

# Require descriptions on variables
rule "terraform_documented_variables" {
  enabled = true
}

# Require descriptions on outputs
rule "terraform_documented_outputs" {
  enabled = true
}

# Ensure variables have type declarations
rule "terraform_typed_variables" {
  enabled = true
}

# Standard module structure
rule "terraform_standard_module_structure" {
  enabled = true
}

# Unused declarations
rule "terraform_unused_declarations" {
  enabled = true
}

# Require version constraints
rule "terraform_required_version" {
  enabled = true
}

# Require provider version constraints
rule "terraform_required_providers" {
  enabled = true
}

# Deprecated syntax
rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Comment syntax
rule "terraform_comment_syntax" {
  enabled = true
}

# Empty list equality checks
rule "terraform_empty_list_equality" {
  enabled = true
}

# Workspace remote
rule "terraform_workspace_remote" {
  enabled = true
}
