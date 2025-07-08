resource "aws_ecs_cluster" "main" {
  name = "devops-ecs-cluster"
}

resource "aws_ecr_repository" "apache" {
  name = "apache-demo"
}

resource "aws_ecs_task_definition" "apache" {
  family                   = "apache"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  container_definitions    = jsonencode([{
    name      = "apache",
    image     = "${aws_ecr_repository.apache.repository_url}:latest",
    cpu       = 256,
    memory    = 512,
    essential = true,
    portMappings = [{
      containerPort = 80,
      hostPort      = 80
    }]
  }])
}

