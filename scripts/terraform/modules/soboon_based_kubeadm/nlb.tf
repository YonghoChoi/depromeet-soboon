//module "elb_http" {
//  source  = "terraform-aws-modules/elb/aws"
//  version = "~> 2.0"
//
//  name = var.name
//
//  subnets         = var.public_subnet_ids
//  security_groups = [var.elb_sg]
//  internal        = false
//
//  listener = [
//    {
//      instance_port     = "30001"
//      instance_protocol = "HTTP"
//      lb_port           = "80"
//      lb_protocol       = "HTTP"
//    },
//    {
//      instance_port     = "30002"
//      instance_protocol = "http"
//      lb_port           = "8080"
//      lb_protocol       = "http"
//    },
//  ]
//
//  health_check = {
//    target              = "HTTP:30001/"
//    interval            = 30
//    healthy_threshold   = 2
//    unhealthy_threshold = 2
//    timeout             = 5
//  }
//
//  // ELB attachments
//  number_of_instances = 1
//  instances           = [aws_spot_instance_request.this.spot_instance_id]
//
//  tags = var.tags
//}