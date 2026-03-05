# DevOps Blanks

A collection of standardized templates, scaffolding scripts, and best practices for modern DevOps workflows. This repository is designed to streamline the initialization and management of Kubernetes projects, Terraform infrastructure, and CI/CD pipelines.

## Repository Structure

- `kubernetes/`: Kubernetes project templates and initialization scripts.
- `terraform/`: Terraform infrastructure templates and initialization scripts.
- `workflows/`: Reusable GitHub Actions workflows (Building, Deploying, Promoting).
- `pr_templates/`: Specialized Pull Request templates (Feature, Bugfix, Infrastructure).
- `checklists/`: Actionable checklists for AWS account setup and repository management.
- `docker/`: Standardized Dockerfile templates.

## Quick Start

### 1. Initialize a Kubernetes Project
Use the provided script to scaffold a new Kubernetes project with Kustomize support and a standardized Makefile.

```bash
bash kubernetes/project_init.sh my-new-cluster
```

### 2. Initialize a Terraform Project
Scaffold a production-ready Terraform project with modular structure and integrated CI/CD.

```bash
bash terraform/project_init.sh my-infrastructure
```

## Core Features

### Standardized Operations
Both Kubernetes and Terraform templates include standardized entry points (Makefiles, READMEs) to ensure a consistent experience across all projects.

### Reusable CI/CD
The repository provides modular GitHub Actions workflows in `.github/workflows/` (linked from `workflows/`):
- **Building**: Docker Hub and AWS image builds.
- **Deploying**: Kustomize and Helm-based deployments.
- **Promoting**: Automated environment promotion (e.g., Staging to Production).

