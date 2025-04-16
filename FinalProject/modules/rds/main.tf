variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "db_sg_id" { type = string }

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "main" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "ecommerce"
  username             = "admin"
  password             = "ChangeMe123!"
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot  = true
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}
