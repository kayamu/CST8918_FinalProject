variable "aws_region" {
  description = "AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for ASG."
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG."
  type        = number
  default     = 2
}

variable "project_name" {
  type = string
}

variable "db_password" {
  description = "Password for the RDS instance."
  type        = string
  sensitive   = true
}
