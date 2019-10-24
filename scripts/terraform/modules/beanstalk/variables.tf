variable "project" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "max_size" {
  type = "string"
  default = "2"
}

variable "key_pair" {
  type = "string"
}

variable "volume_type" {
  type = "string"
  default = "gp2"
}

variable "volume_size" {
  type = "string"
  default = "50"
}

variable "base_tags" {
  type = "map"
}

variable "elb_sg_ids" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "spot_price" {
  type = "string"
  default = "0.2"
}

variable "spot_type" {
  type = "string"
  default = "one-time"
}

variable "wait_for_fulfillment" {
  type = "string"
  default = "true"
}

variable "ami_id" {
  type = "string"
}

variable "ec2_password" {
  type = "string"
}

variable "azs" {
  type = "list"
}

variable "vpc_id" {
  type = "string"
}
variable "min_size" {
  type = "string"
  default = "1"
}

locals {
  name = "${var.project}-${var.environment}"
  elb_settings = [

}