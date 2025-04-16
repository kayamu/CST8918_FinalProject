output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "s3_bucket_name" {
  value = module.s3.s3_bucket_name
}

output "cloudwatch_log_group" {
  value = module.monitoring.cloudwatch_log_group
}
