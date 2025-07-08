# ALB DNS Name
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

# RDS Endpoint
output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

# RDS DB Name
output "rds_db_name" {
  description = "The name of the MySQL database"
  value       = aws_db_instance.mysql.db_name
}

# ECS Cluster name
output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.main.name
}

