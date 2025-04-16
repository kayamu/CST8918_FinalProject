variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "instance_sg_id" { type = string }
variable "alb_target_group_arn" { type = string }
variable "instance_type" { type = string }
variable "desired_capacity" { type = number }

resource "aws_launch_template" "main" {
  name_prefix   = "asg-launch-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.instance_sg_id]
  user_data = base64encode("#!/bin/bash\nyum update -y\nyum install -y httpd\nsystemctl start httpd\nsystemctl enable httpd\necho 'Hello from ASG instance' > /var/www/html/index.html\n")
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "main-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.private_subnets
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  target_group_arns         = [var.alb_target_group_arn]
  health_check_type         = "EC2"
  health_check_grace_period = 300
}

output "asg_name" {
  value = aws_autoscaling_group.main.name
}
