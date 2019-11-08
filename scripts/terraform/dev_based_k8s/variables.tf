variable "project" {
  type = "string"
  default = "toy"
}

variable "environment" {
  type = "string"
  default = "develop"
}

locals {
  name = "${var.project}-${var.environment}"
  base_tags = {
    Project = var.project
    Terraform = "true"
    Environment = var.environment
  }
  access_cidr_block = "168.126.184.69/32"
}