CST8918 Final Project – Terraform‑Defined AWS E‑Commerce Infrastructure

This repository provides a production‑grade Terraform configuration for a scalable, highly available AWS environment tailored to an e‑commerce platform. It encapsulates best practices I have applied as a Senior Cloud & DevOps engineer into a modular, repeatable blueprint.

ARCHITECTURE OVERVIEW
	1.	Virtual Private Cloud (VPC) and Subnets
• A dedicated VPC (default CIDR: 10.0.0.0/16) is divided into two public and two private subnets across two Availability Zones.
• Public subnets host the Application Load Balancer; private subnets contain backend EC2 instances.
	2.	Internet Gateway
• Attached only to public subnets so external traffic reaches the ALB, while backend compute remains isolated.
	3.	Application Load Balancer (ALB)
• Deployed in public subnets to distribute HTTP requests to healthy instances in private subnets.
• Health checks and listener settings reflect configurations refined in real‑world, high‑traffic deployments.
	4.	Auto Scaling Group (ASG)
• Launches EC2 instances from the latest Amazon Linux 2 AMI via a launch template.
• Default scaling parameters (min=1, desired=2, max=3) can be adjusted in variables.tf to match workload patterns.
	5.	Security Groups
• ALB Security Group allows inbound HTTP (port 80) from any IPv4 source and unrestricted outbound.
• Instance Security Group permits inbound HTTP only from the ALB’s security group and unrestricted outbound.

CONFIGURATION AND USAGE

Variables File (variables.tf)
All critical settings—AWS region, VPC/subnet CIDRs, AMI ID, instance type, scaling thresholds—are declared here for easy customization.

Outputs File (outputs.tf)
Exposes VPC ID, subnet IDs, and the ALB DNS name after deployment.

DEPLOYMENT STEPS
	1.	Ensure AWS credentials are configured with permissions to create VPCs, subnets, EC2, ALB, and related resources.
	2.	Review and, if necessary, update values in variables.tf.
	3.	Run:
terraform init
terraform plan
terraform apply
	4.	Note the outputs (VPC ID, subnet IDs, ALB DNS name) for validation.

TEARDOWN

• Execute terraform destroy to remove all provisioned resources and avoid ongoing AWS charges.

EXTENSION RECOMMENDATIONS

• Add a NAT Gateway for outbound internet access from private subnets.
• Integrate Amazon RDS in private subnets for reliable data persistence.
• Enable HTTPS termination by attaching an ACM certificate to the ALB listener.
• Configure AWS CloudWatch alarms and centralized logging for operational visibility.
• Store Terraform state in an S3 backend with DynamoDB locking to support team collaboration and prevent state corruption.

This configuration embodies proven security, scalability, and maintainability patterns. It serves both as the CST8918 Final Project submission and a solid foundation for production deployments.

Author: Muharrem Kaya
Date: April 16, 2025