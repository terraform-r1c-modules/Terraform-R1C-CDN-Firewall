# Makefile for Terraform module development

.PHONY: help init validate fmt lint clean test security pre-commit
.DEFAULT_GOAL := help

# Default target
help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Development tasks
init: ## Initialize Terraform
	terraform init -upgrade
	cd examples/basic && terraform init -upgrade
	cd examples/advanced && terraform init -upgrade

validate: ## Validate Terraform configuration
	terraform validate
	cd examples/basic && terraform validate
	cd examples/advanced && terraform validate

fmt: ## Format Terraform files
	terraform fmt -recursive

fmt-check: ## Check Terraform formatting
	terraform fmt -check -recursive -diff

lint: ## Run TFLint
	tflint --recursive

# Security scanning
security: ## Run security scans
	tfsec .

# Pre-commit hooks
pre-commit: ## Run pre-commit hooks
	pre-commit run --all-files

pre-commit-install: ## Install pre-commit hooks
	pre-commit install

# Cleanup
clean: ## Clean up Terraform files
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	find . -type f -name "*.tfplan" -delete 2>/dev/null || true
	find . -type f -name "terraform.tfstate*" -delete 2>/dev/null || true
