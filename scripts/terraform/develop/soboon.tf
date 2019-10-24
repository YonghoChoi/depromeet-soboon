provider "aws" {
  region = "ap-southeast-1"
}

// backend 설정에 변수 지정 불가능
terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "yongho1037"
    key = "tfstates/soboon-develop.tfstate"
//    encrypt = true
  }
}

module "elastic_beanstalk_application" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=tags/0.4.0"
  namespace   = var.namespace
  stage       = var.environment
  name        = local.name
  attributes  = var.attributes
  tags        = local.base_tags
  delimiter   = var.delimiter
  description = "soboon elastic beanstalk application"
}

module "elastic_beanstalk_environment" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=tags/0.17.0"
  namespace                  = var.namespace
  stage                      = var.environment
  name                       = local.name
  attributes                 = var.attributes
  tags                       = local.base_tags
  delimiter                  = var.delimiter
  description                = "soboon elastic beanstalk environment"
  region                     = var.region
  availability_zone_selector = var.availability_zone_selector
//  dns_zone_id                = var.dns_zone_id

  wait_for_ready_timeout             = var.wait_for_ready_timeout
  elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name
  environment_type                   = var.environment_type
  loadbalancer_type                  = var.loadbalancer_type
  elb_scheme                         = var.elb_scheme
  tier                               = var.tier
  version_label                      = var.version_label
  force_destroy                      = var.force_destroy

  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type

  autoscale_min             = var.autoscale_min
  autoscale_max             = var.autoscale_max
  autoscale_measure_name    = var.autoscale_measure_name
  autoscale_statistic       = var.autoscale_statistic
  autoscale_unit            = var.autoscale_unit
  autoscale_lower_bound     = var.autoscale_lower_bound
  autoscale_lower_increment = var.autoscale_lower_increment
  autoscale_upper_bound     = var.autoscale_upper_bound
  autoscale_upper_increment = var.autoscale_upper_increment

  vpc_id                  = module.vpc.vpc_id
  loadbalancer_subnets    = module.vpc.public_subnets
  application_subnets     = module.vpc.private_subnets
  allowed_security_groups = [module.vpc.default_security_group_id]

  rolling_update_enabled  = var.rolling_update_enabled
  rolling_update_type     = var.rolling_update_type
  updating_min_in_service = var.updating_min_in_service
  updating_max_batch      = var.updating_max_batch

  healthcheck_url  = var.healthcheck_url
  application_port = var.application_port

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
  // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
  solution_stack_name = var.solution_stack_name

  additional_settings = var.additional_settings
  env_vars            = var.env_vars
}

module "elasticstack" {
  source = "../modules/elasticstack"
  environment = "develop"
  instance_type = "m4.large"
  key_pair = "yongho1037"
  project = "soboon"
  public_subnet_ids = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  es_sg_ids = [module.soboon-sg.this_security_group_id]
  ami_id = data.aws_ami.ubuntu.id
  ec2_password = "ubuntu"
  azs = local.azs
  base_tags = {
    Project = var.project
    Terraform = "true"
    Environment = var.environment
  }
}

locals {
  azs = data.aws_availability_zones.available.names
}