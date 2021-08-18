data "aws_ami" "latest_ecs" {
  most_recent = true
  owners = [ "591542846629" ] # AWS

  filter {
    name = "name"
    values = [ "*amazon-ecs-optimized" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
}

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name = "ecs-launch-configuration"
  image_id = data.aws_ami.latest_ecs.id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

  root_block_device {
    volume_type = "standard"
    volume_size = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [aws_security_group.ecs_public_sg.id]
  associate_public_ip_address = "true"
  key_name = var.key_pair
  # TODO : make this a file
  user_data = <<EOF
              #!/bin/bash
              echo ECS_CLUSTER="ECS_cluster" >> /etc/ecs/ecs.config
              EOF
}