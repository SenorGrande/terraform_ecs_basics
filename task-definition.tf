data "aws_ecs_task_definition" "nginx" {
  task_definition = aws_ecs_task_definition.nginx.family
}

data "template_file" "ecs-task-definition" {
  template = file("task-definition.json")
  vars = {
    container_name  = "ecs-task"
    container_image = "nodered/node-red"
    container_port  = 1880
    host_port       = 1880
  }
}

# TODO : separate this into a json file
resource "aws_ecs_task_definition" "nginx" {
  family = "nginx"
  # container_definitions = file("task-definition.json")
  container_definitions = data.template_file.ecs-task-definition.rendered
  # container_definitions = templatefile(
  #   "task-definition.tmpl", 
  #   { 
  #     container_name = "ecs-nginx",
  #     # container_image = "[ID].dkr.ecr.ap-southeast-2.amazonaws.com/test_nginx:latest"
  #     container_image = "nginx"
  #   }
  # )
}

resource "aws_ecs_service" "ecs-service" {
  name = "ecs-service"
  iam_role = aws_iam_role.ecs-service-role.name
  cluster = aws_ecs_cluster.ecs-cluster.id 
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count = 2

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    container_port = 1880
    container_name = "ecs-task"
  }

  depends_on = [aws_alb_target_group.ecs-target-group, aws_alb.ecs-load-balancer]
}