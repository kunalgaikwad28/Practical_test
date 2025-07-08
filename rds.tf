# Reference existing private subnets
data "aws_subnet" "private1" {
  id = "subnet-082d2f49617771036"
}

data "aws_subnet" "private2" {
  id = "subnet-0b7c471eacfdd8a43"
}

# Reference existing ECS security group
data "aws_security_group" "ecs_sg" {
  id = "sg-0dd7311c01a0a323e"
}

# Reference existing VPC (you should already have this declared in alb.tf)


# Create DB Subnet Group using private subnets
resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = [
    data.aws_subnet.private1.id,
    data.aws_subnet.private2.id
  ]

  tags = {
    Name = "MySQL Subnet Group"
  }
}

# Create a security group for RDS
resource "aws_security_group" "mysql" {
  name        = "mysql-sg"
  description = "Allow ECS to access RDS"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.ecs_sg.id]  # Correct reference
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql-sg"
  }
}

# Create RDS MySQL instance
resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "password123"  # Use Secrets Manager in production
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.mysql.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "devops-rds"
  }
}

