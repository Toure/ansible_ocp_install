# Makefile for Disconnected OpenShift Installation using Ansible

# --- Configuration ---
# These variables can be overridden from the command line, e.g., `make install INVENTORY=inventory.prod`
PLAYBOOK        := playbook.yml
INVENTORY       := inventory.ini
ROLES_PATH      := roles/
ANSIBLE_LINT    := ansible-lint

# List of required Ansible collections
COLLECTIONS     := kubernetes.core amazon.aws community.general community.hashi_vault

.DEFAULT_GOAL := help
.PHONY: help deps lint syntax-check dry-run test install clean

##
## ------------------ Help and Setup Targets ------------------
##
help: ## Show this help message.
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

deps: ## Install pre-flight dependencies (Ansible collections).
	@echo "--> Checking for and installing required Ansible collections..."
	@if ! command -v ansible-galaxy &> /dev/null; then \
		echo "ERROR: 'ansible-galaxy' command not found. Please install Ansible."; exit 1; \
	fi
	@ansible-galaxy collection install $(COLLECTIONS)
	@echo "--> NOTE: This target checks dependencies on the control node."
	@echo "--> The playbook itself will check for remote host dependencies (e.g., podman)."


##
## ------------------ Testing Targets ------------------
##
lint: ## Lint the Ansible playbook and roles for style and errors.
	@echo "--> Linting playbook and roles..."
	@if ! command -v $(ANSIBLE_LINT) &> /dev/null; then \
		echo "WARNING: 'ansible-lint' not found. Skipping linting."; \
		echo "         Install it with: pip install ansible-lint"; \
	else \
		$(ANSIBLE_LINT) $(PLAYBOOK) --roles-dir $(ROLES_PATH); \
	fi

syntax-check: ## Check the Ansible playbook for syntax errors.
	@echo "--> Checking playbook syntax..."
	@ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --syntax-check

dry-run: ## Run the playbook in check mode (no changes will be made).
	@echo "--> Running playbook in Dry-Run (Check) mode..."
	@ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --check

test: lint syntax-check dry-run ## Run all tests (lint, syntax-check, dry-run).
	@echo ""
	@echo "--> All tests passed successfully!"


##
## ------------------ Execution Targets ------------------
##
install: deps ## Run the full installation playbook.
	@echo "--> Starting the OpenShift disconnected installation..."
	@ansible-playbook $(PLAYBOOK) -i $(INVENTORY)

clean: ## DANGER: Remove all generated installation artifacts.
	@echo "--> Cleaning up generated artifacts..."
	@read -p "WARNING: This will delete all generated configs, manifests, and ignition files in roles/openshift_disconnected_install/defaults/ocp_install_dir. Are you sure? (y/N) " -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		INSTALL_DIR=$$(grep 'ocp_install_dir:' roles/openshift_disconnected_install/defaults/main.yml | awk '{print $$2}'); \
		if [ -n "$$INSTALL_DIR" ]; then \
			echo "Deleting contents of $$INSTALL_DIR..."; \
			rm -rf $$INSTALL_DIR/{*.ign,*.yaml,*.log,auth,manifests,metadata.json,results-*}; \
			echo "Cleanup complete."; \
		else \
			echo "Could not determine installation directory. No files deleted."; \
		fi \
	else \
		echo "Cleanup aborted."; \
	fi
