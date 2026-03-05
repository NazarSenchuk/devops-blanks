module "vpc" {
  source = "./modules/vpc"

  cidr_block   = var.vpc_cidr
  project_name = var.project_name
}

# Add more resources/modules here
