variable "project" {
  type = "string"
  default = "soboon"
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
}