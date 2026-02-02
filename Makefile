.PHONY: help release bump-version lint package test clean

# Default target
.DEFAULT_GOAL := help

# Chart name
CHART_NAME := universal
CHART_FILE := Chart.yaml

# Colors for output
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
NC     := \033[0m # No Color

help: ## Show this help message
	@echo "$(GREEN)Universal Helm Chart - Makefile Commands$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make $(YELLOW)<target>$(NC)\n\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

bump-version: ## Update version in Chart.yaml (Usage: make bump-version VERSION=1.6.0)
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)Error: VERSION is required$(NC)"; \
		echo "Usage: make bump-version VERSION=1.6.0"; \
		exit 1; \
	fi
	@if ! echo "$(VERSION)" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$'; then \
		echo "$(RED)Error: Invalid version format. Use semantic versioning (e.g., 1.6.0)$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Updating Chart.yaml to version $(VERSION)$(NC)"
	@sed -i.bak 's/^version: .*/version: $(VERSION)/' $(CHART_FILE)
	@sed -i.bak 's/^appVersion: .*/appVersion: $(VERSION)/' $(CHART_FILE)
	@rm -f $(CHART_FILE).bak
	@if command -v helm-docs >/dev/null 2>&1; then \
		echo "$(GREEN)Regenerating README.md$(NC)"; \
		helm-docs; \
	else \
		echo "$(YELLOW)Warning: helm-docs not found, skipping README regeneration$(NC)"; \
	fi
	@echo "$(GREEN)✓ Version updated to $(VERSION)$(NC)"

release: ## Create a new release (Usage: make release VERSION=1.6.0)
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)Error: VERSION is required$(NC)"; \
		echo "Usage: make release VERSION=1.6.0"; \
		exit 1; \
	fi
	@echo "$(GREEN)Starting release process for version $(VERSION)$(NC)"
	@if ! git diff-index --quiet HEAD --; then \
		echo "$(RED)Error: You have uncommitted changes$(NC)"; \
		exit 1; \
	fi
	@if git rev-parse $(VERSION) >/dev/null 2>&1; then \
		echo "$(RED)Error: Tag $(VERSION) already exists$(NC)"; \
		exit 1; \
	fi
	@CURRENT_BRANCH=$$(git branch --show-current); \
	if [ "$$CURRENT_BRANCH" != "main" ]; then \
		echo "$(YELLOW)Warning: You're on branch '$$CURRENT_BRANCH', not 'main'$(NC)"; \
		read -p "Continue? (y/n) " -n 1 -r; \
		echo; \
		if [[ ! $$REPLY =~ ^[Yy]$$ ]]; then \
			echo "$(RED)Release cancelled$(NC)"; \
			exit 1; \
		fi; \
	fi
	@$(MAKE) bump-version VERSION=$(VERSION)
	@echo "$(GREEN)Committing changes$(NC)"
	@git add $(CHART_FILE) README.md charts/common/README.md 2>/dev/null || git add $(CHART_FILE) README.md 2>/dev/null || git add $(CHART_FILE)
	@git commit -m "chore: bump version to $(VERSION)" -m "" -m "Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
	@echo "$(GREEN)Creating tag $(VERSION)$(NC)"
	@git tag -a $(VERSION) -m "Release $(VERSION)"
	@echo "$(GREEN)Pushing to remote$(NC)"
	@git push origin $$(git branch --show-current)
	@git push origin $(VERSION)
	@echo ""
	@echo "$(GREEN)✓ Release $(VERSION) completed successfully!$(NC)"
	@echo "$(YELLOW)GitHub Actions will automatically create the release.$(NC)"
	@echo ""
	@echo "Check workflow: gh run watch"
	@echo "View release: https://github.com/okassov/universal-chart/releases/tag/$(VERSION)"

lint: ## Lint the Helm chart
	@echo "$(GREEN)Linting Helm chart$(NC)"
	@helm lint .

package: ## Package the Helm chart
	@echo "$(GREEN)Packaging Helm chart$(NC)"
	@helm package .
	@echo "$(GREEN)✓ Chart packaged: $(CHART_NAME)-$$(grep '^version:' $(CHART_FILE) | awk '{print $$2}').tgz$(NC)"

test: ## Run chart tests
	@echo "$(GREEN)Testing Helm chart$(NC)"
	@helm lint .
	@echo "$(GREEN)Rendering templates$(NC)"
	@helm template test . --debug > /dev/null
	@echo "$(GREEN)✓ All tests passed$(NC)"

clean: ## Clean packaged charts
	@echo "$(GREEN)Cleaning packaged charts$(NC)"
	@rm -f $(CHART_NAME)-*.tgz
	@echo "$(GREEN)✓ Cleaned$(NC)"

version: ## Show current chart version
	@grep '^version:' $(CHART_FILE) | awk '{print $$2}'
