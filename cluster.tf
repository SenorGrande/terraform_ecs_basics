# Provides an ECS cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ECS_cluster"
}