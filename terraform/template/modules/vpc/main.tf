resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.this.id
}

variable "cidr_block" {
  type = string
}

variable "project_name" {
  type = string
}
