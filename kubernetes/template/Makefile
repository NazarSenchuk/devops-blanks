# Kubernetes Project Makefile

.PHONY: help init deploy undeploy lint logs

# Default target: show help
help:
	@echo "Kubernetes Project Management"
	@echo "----------------------------"
	@echo "  make init      - Initialize environment (e.g., check for kubectl)"
	@echo "  make deploy    - Apply all manifests using Kustomize"
	@echo "  make undeploy  - Remove all manifests"
	@echo "  make lint      - Lint Kubernetes manifests"
	@echo "  make logs      - Stream logs (requires APP_NAME environment variable)"

init:
	@command -v kubectl >/dev/null 2>&1 || { echo >&2 "Error: kubectl is not installed."; exit 1; }
	@command -v kustomize >/dev/null 2>&1 || { echo >&2 "Error: kustomize is not installed."; exit 1; }
	@echo " Tools are ready!"

deploy:
	@echo " Deploying to Kubernetes..."
	kubectl apply -k overlays/development

undeploy:
	@echo " Undeploying from Kubernetes..."
	kubectl delete -k overlays/development

lint:
	@echo " Linting manifests..."
	kustomize build overlays/development | kubectl apply --dry-run=client -f -

logs:
	@if [ -z "$(APP_NAME)" ]; then \
		echo "Error: APP_NAME is not set. Use: make logs APP_NAME=my-app"; \
		exit 1; \
	fi
	kubectl logs -f -l app=$(APP_NAME)
