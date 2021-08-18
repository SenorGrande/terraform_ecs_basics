variable "region" {
  default = "ap-southeast-2"
}

provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_ecr_repository" "nginx" {
  name = "test_nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

data "template_file" "ecr-untagged-policy" {
  template = file("ecr-untagged-policy.json")
  # vars = {
  #   container_name = "ecs-nginx"
  # }
}

# Policy on untagged images
resource "aws_ecr_lifecycle_policy" "nginx-untagged-policy" {
  repository = aws_ecr_repository.nginx.name

  policy = data.template_file.ecr-untagged-policy.rendered
}

data "template_file" "ecr-tagged-policy" {
  template = file("ecr-tagged-policy.json")
}