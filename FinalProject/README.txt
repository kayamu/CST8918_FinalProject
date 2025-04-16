# AWS E-Commerce Platform Infrastructure - Terraform

## Overview
This Terraform configuration deploys a scalable, highly available web application infrastructure on AWS, suitable for an e-commerce platform. The architecture includes a VPC, public and private subnets across two Availability Zones, an Application Load Balancer (ALB), an Auto Scaling Group (ASG) for backend servers, and security groups to control network access.

## Architecture Components

### 1. VPC
- A dedicated Virtual Private Cloud (VPC) with a customizable CIDR block (default: 10.0.0.0/16).

### 2. Subnets
- **Public Subnets (2):**
  - Located in separate Availability Zones for high availability.
  - Used for internet-facing resources (ALB).
- **Private Subnets (2):**
  - Also in separate AZs.
  - Used for backend EC2 instances (ASG), isolated from direct internet access.

### 3. Internet Gateway
- Allows resources in public subnets to access the internet.

### 4. Application Load Balancer (ALB)
- Deployed in public subnets.
- Distributes HTTP traffic to backend EC2 instances in private subnets.
- Exposes a DNS endpoint for client access.

### 5. Auto Scaling Group (ASG)
- Manages EC2 instances in private subnets.
- Uses a Launch Template with the latest Amazon Linux 2 AMI.
- Automatically scales the number of instances based on desired capacity (default: 2, configurable).

### 6. Security Groups
- **ALB Security Group:**
  - Allows inbound HTTP (port 80) from anywhere (0.0.0.0/0).
  - Allows all outbound traffic.
- **App/EC2 Security Group:**
  - Allows inbound HTTP (port 80) only from the ALB security group.
  - Allows all outbound traffic.

## Variables
- All major parameters (region, VPC/subnet CIDRs, instance type, ASG size) are configurable in `variables.tf`.

## Outputs
- VPC ID, subnet IDs, and the ALB DNS name are output after deployment for reference.

## Deployment Instructions
1. **Configure AWS Credentials:**
   - Ensure your AWS CLI or environment is set up with credentials that have permissions to create VPCs, subnets, EC2, ALB, and related resources.
2. **Review Variables:**
   - Edit `variables.tf` to adjust region, CIDRs, instance type, or ASG size as needed.
3. **Initialize Terraform:**
   - Run `terraform init` to initialize the working directory.
4. **Plan Deployment:**
   - Run `terraform plan` to review the resources that will be created.
5. **Apply Deployment:**
   - Run `terraform apply` and confirm to provision the infrastructure.
6. **Access the Application:**
   - After apply, find the ALB DNS name in the Terraform output. Use this DNS to access your application (ensure your app is listening on port 80).

## Teardown Instructions
- To destroy all resources, run `terraform destroy` and confirm.

## Extending the Architecture
- **NAT Gateway:** Add if backend instances need outbound internet access (e.g., for updates).
- **Database:** Add RDS or other managed database in private subnets for persistent storage.
- **HTTPS:** Add an ACM certificate and update the ALB listener for secure HTTPS traffic.
- **Monitoring:** Integrate with CloudWatch for logging and monitoring.

## Notes
- This setup does not include a NAT Gateway or database by default.
- Make sure to clean up resources to avoid ongoing AWS charges.
- For production, consider using remote state storage (e.g., S3 with DynamoDB locking).

---
Author: [Your Name]
Date: April 16, 2025
