module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = local.azs
  private_subnets = ["10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"]
  public_subnets  = ["10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19"]

  enable_dns_support   = true
  enable_dns_hostnames = true
  single_nat_gateway = true
  enable_nat_gateway = true

  tags = merge(local.base_tags, map("Name", local.name))
}

module "soboon-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = local.name
  description = "soboon backend security group"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = local.base_tags
}

module "elasticstack-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${local.name}-elasticstack"
  description = "soboon backend security group"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = 5601
      to_port = 5601
      protocol = "tcp"
      description = "Allow kibana"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_with_source_security_group_id = [
    {
      rule = "elasticsearch-rest-tcp"
      source_security_group_id = module.soboon-sg.this_security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = local.base_tags
}