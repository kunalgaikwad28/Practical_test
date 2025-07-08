# alb.tf

# Data sources to reference existing AWS resources
data "aws_vpc" "selected" {
  id = "vpc-079c1cc1181779767"  # Your existing VPC ID
}

data "aws_subnet" "subnet1" {
  id = "subnet-0b8df1ddf873f6712"  # Your first subnet ID
}

data "aws_subnet" "subnet2" {
  id = "subnet-0fe88234d2a26d1d5"  # Your second subnet ID
}

data "aws_security_group" "selected" {
  id = "sg-0dd7311c01a0a323e"  # Your security group ID
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "devops-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]  # Reference via data source
  security_groups    = [data.aws_security_group.selected.id]  # Reference via data source
}

# Target Group
resource "aws_lb_target_group" "nginx" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id  # Reference via data source
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}
