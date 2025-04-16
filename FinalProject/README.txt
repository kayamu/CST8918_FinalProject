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

DATABASE TIER

• Amazon RDS (MySQL) instance is provisioned in private subnets for secure, persistent data storage.
• Database security group only allows inbound MySQL traffic from EC2 instances in the application security group.

STORAGE

• An S3 bucket is created for storing application data and logs. The bucket name is output after deployment.

MONITORING & LOGGING

• CloudWatch Log Group is provisioned for EC2/application logs.
• A CloudWatch alarm is set up to monitor high CPU utilization in the Auto Scaling Group.

MODULAR DESIGN

This project uses a modular Terraform structure. Each major AWS component (VPC, Security, ALB, ASG, RDS, S3, Monitoring) is defined in its own module under the `modules/` directory. This approach improves code reusability, clarity, and maintainability. You can customize or reuse individual modules for other projects easily.

MODULAR STRUCTURE DETAILS

The infrastructure is split into the following modules under the `modules/` directory:

- **vpc/**: Creates the VPC and both public/private subnets.
- **security/**: Defines all security groups (ALB, EC2, RDS).
- **alb/**: Provisions the Application Load Balancer, target group, and listener.
- **asg/**: Sets up the Auto Scaling Group and Launch Template for EC2 instances.
- **rds/**: Deploys an Amazon RDS (MySQL) instance in private subnets.
- **s3/**: Creates an S3 bucket for application data and logs.
- **monitoring/**: Configures CloudWatch log group and a CPU utilization alarm for the ASG.

Each module is self-contained and exposes outputs to be consumed by other modules or the root configuration. This makes the infrastructure reusable and easy to maintain.

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

OUTPUTS (Terraform Apply)

After running terraform apply, the following outputs are provided for validation and integration:

- VPC ID: vpc-019bed2fbc7afa816
- Public Subnet IDs: subnet-0922c67fbdac46895, subnet-03629f54d85f53e9a
- Private Subnet IDs: subnet-0922f50f9b224459d, subnet-087029494d70202df
- ALB DNS Name: main-alb-1637770781.us-east-1.elb.amazonaws.com
- RDS Endpoint: terraform-20250416205243729300000004.c1ige4ee69n4.us-east-1.rds.amazonaws.com:3306
- S3 Bucket Name: cst8918-finalproject
- CloudWatch Log Group: /aws/ec2/CST8918_FinalProject

You can use these outputs to connect your application, validate resource creation, or integrate with other AWS services.

TEARDOWN

• Execute terraform destroy to remove all provisioned resources and avoid ongoing AWS charges.

EXTENSION RECOMMENDATIONS

• Add a NAT Gateway for outbound internet access from private subnets.
• Integrate Amazon RDS in private subnets for reliable data persistence.
• Enable HTTPS termination by attaching an ACM certificate to the ALB listener.
• Configure AWS CloudWatch alarms and centralized logging for operational visibility.
• Store Terraform state in an S3 backend with DynamoDB locking to support team collaboration and prevent state corruption.

ASSUMPTIONS & LIMITATIONS

• The RDS password is hardcoded for demonstration; use AWS Secrets Manager for production.
• No automated backup or multi-AZ for RDS (can be enabled for production).
• S3 bucket access policies are not restricted for simplicity.
• Application-level log shipping to CloudWatch is not configured by default.

KNOWN ISSUES & TROUBLESHOOTING

• If RDS provisioning fails, ensure your AWS account has sufficient quota and the selected instance type is available in your region.
• For S3 bucket naming conflicts, change the project_name variable.

This configuration embodies proven security, scalability, and maintainability patterns. It serves both as the CST8918 Final Project submission and a solid foundation for production deployments.

Author: Muharrem Kaya
Date: April 16, 2025