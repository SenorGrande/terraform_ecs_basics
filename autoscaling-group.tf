# ? Provides an AutoScaling Group resource to the EC2
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "ecs-autoscaling-group"
  max_size = 1
  min_size = 1
  desired_capacity = 1
  vpc_zone_identifier = [aws_subnet.ecs_pub_subnet_0.id, aws_subnet.ecs_pub_subnet_1.id]
  launch_configuration = aws_launch_configuration.ecs-launch-configuration.name
  health_check_type = "ELB"

  # This tag will propogate to the EC2 created
  tag {
    key = "Name"
    value = "ECS EC2"
    propagate_at_launch = true
  }
}