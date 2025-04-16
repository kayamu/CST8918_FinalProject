module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.security.alb_sg_id
}

module "asg" {
  source                = "./modules/asg"
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  instance_sg_id        = module.security.instance_sg_id
  alb_target_group_arn  = module.alb.target_group_arn
}

module "rds" {
  source          = "./modules/rds"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  db_sg_id        = module.security.db_sg_id
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

module "monitoring" {
  source      = "./modules/monitoring"
  asg_name    = module.asg.asg_name
  project_name = var.project_name
}

data "aws_availability_zones" "available" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
