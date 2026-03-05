# Terraform Project Template

This directory contains a production-ready Terraform scaffolding designed for scalability and maintainability.

## Project Structure

- `main.tf`: Defines the primary infrastructure resources and module calls.
- `variables.tf`: Declare variables for customization and environment-specific overrides.
- `outputs.tf`: Define the outputs to share resource details.
- `providers.tf`: Configure cloud providers (AWS, Azure, GCP) and backend state storage.
- `modules/`: Root directory for local, reusable infrastructure components.
- `.github/workflows/`: CI/CD pipelines for automated `fmt`, `plan`, and `apply`.

## Getting Started

### 1. Initialize the Project
Clone this template using the [project_init.sh](../project_init.sh) script or copy these files manually.

### 2. Configure Your Backend
In `providers.tf`, uncomment and update the `backend "s3"` block to point to your state bucket.

### 3. Review Variables
Check `variables.tf` to set your project name, region, and CIDR blocks.

### 4. Run Terraform
```bash
terraform init
terraform plan
terraform apply
```

## Best Practices

1. **State Management**: Always use remote state storage with state locking (e.g., S3 + DynamoDB).
2. **Modularity**: Break down resources into small, focused modules. Look at `modules/vpc` for an example.
3. **CI/CD Integrated**: Use the included GitHub Actions workflow to ensure consistent formatting and automated testing.
4. **Environment Separation**: For multiple environments, use Terraform Cloud, workspaces, or separate directories with unique backend keys.
