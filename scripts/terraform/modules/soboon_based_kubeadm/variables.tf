variable "name" {
    type = "string"
}

variable "key_pair" {
    type = "string"
}

variable "es_instance_type" {
    type = "string"
}

variable "soboon_web_instance_type" {
    type = "string"
}

variable "ami_name" {
    type = "string"
    default = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}

variable "ami_owner" {
    type = "string"
    default = "099720109477"
}

variable "iam_instance_profile_name" {
    type = "string"
    default = ""
}

variable "security_group_ids" {
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

variable "volume_size" {
    type = "string"
}

variable "private_subnet_ids" {
    type = "list"
}

variable "public_subnet_ids" {
    type = "list"
}

variable "password" {
    type = "string"
    default = "ubuntu"
}

variable "environment" {
    type = "string"
}

variable "es_ami_id" {
    type = "string"
}

variable "soboon_ami_id" {
    type = "string"
}

variable "vpc_id" {
    type = "string"
}

variable "elb_sg" {
    type = "string"
}

variable "tags" {
    description = "모든 리소스에 추가되는 tag 맵"
    type        = "map"
}