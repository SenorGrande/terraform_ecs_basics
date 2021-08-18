# Provides a Load Balancer resource
resource "aws_alb" "ecs-load-balancer" {
  name = "ecs-load-balancer"
  security_groups = [aws_security_group.ecs_public_sg.id]
  subnets = [aws_subnet.ecs_pub_subnet_0.id, aws_subnet.ecs_pub_subnet_1.id]

  tags = {
    Name = "ecs-load-balancer"
    Description = "Managed by Terraform"
  }
}

# ? Provides a Target Group resource for use with Load Balancer resource
resource "aws_alb_target_group" "ecs-target-group" {
  name = "ecs-target-group"
  port = var.port
  protocol = var.protocol
  vpc_id = aws_vpc.ecs_vpc.id

  health_check {
    healthy_threshold = "5"
    unhealthy_threshold = "2"
    interval = "30"
    matcher = "200"
    path = "/"
    port = "traffic-port"
    protocol = var.protocol
    timeout = "5"
  }

  tags = {
    Name = "ecs-target-group"
  }

  # TODO : does this need to depend on aws_alb
}

# ? Provides a Load Balancer Listener resoruce
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.ecs-load-balancer.arn
  port = var.port
  protocol = var.protocol

  default_action {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    type = "forward"
  }
}