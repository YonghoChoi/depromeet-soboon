provider "aws" {
  region = "ap-northeast-2"
}

// backend 설정에 변수 지정 불가능
terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "soboon"
    key = "tfstates/soboon-develop.tfstate"
//    encrypt = true
  }
}

module "soboon" {
  source = "../modules/soboon_based_kubeadm"
  name = local.name
  environment = "dev"
  es_instance_type = "m4.large"
  soboon_web_instance_type = "m4.large"
  key_pair = "soboon"
  security_group_ids = [module.soboon-sg.this_security_group_id]
  subnet_ids = module.vpc.public_subnets
  tags = local.base_tags
  volume_size = "50"
  es_ami_id = data.aws_ami.ubuntu.id
  soboon_ami_id = data.aws_ami.ubuntu.id
}

locals {
  azs = data.aws_availability_zones.available.names
}