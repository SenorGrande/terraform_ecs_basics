# Define a vpc
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "200.0.0.0/16"
  tags = {
    Name = "ecsVPC"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "ecs_ig" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags = {
    Name = "ecsIG"
  }
}

# Public subnet
resource "aws_subnet" "ecs_pub_subnet_0" {
  vpc_id = aws_vpc.ecs_vpc.id
  cidr_block = "200.0.0.0/24"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "ecs-subnet-0"
  }
}

# Routing table for public subnet
resource "aws_route_table" "ecs_pub_subnet_0_routing_table" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_ig.id
  }
  tags = {
    Name = "ecs-route_table-0"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "ecs_pub_subnet_0_routing_table_association" {
  subnet_id = aws_subnet.ecs_pub_subnet_0.id
  route_table_id = aws_route_table.ecs_pub_subnet_0_routing_table.id
}

# This is our second subnet (we need 2 minimum)
# Public subnet
resource "aws_subnet" "ecs_pub_subnet_1" {
  vpc_id = aws_vpc.ecs_vpc.id
  cidr_block = "200.0.10.0/24"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "ecs-subnet-1"
  }
}

# Routing table for public subnet
resource "aws_route_table" "ecs_pub_subnet_1" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_ig.id
  }
  tags = {
    Name = "ecs-route_table-1"
  }
}

# Routing table for public subnet
resource "aws_route_table" "ecs_pub_subnet_1_routing_table" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_ig.id
  }
  tags = {
    Name = "ecs-route_table-1"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "ecs_pub_subnet_1_routing_table_association" {
  subnet_id = aws_subnet.ecs_pub_subnet_1.id
  route_table_id = aws_route_table.ecs_pub_subnet_1_routing_table.id
}

# ECS Instance Security Group
resource "aws_security_group" "ecs_public_sg" {
  name = "ecs_public_sg"
  description = "ECS EC2 public access security group"
  vpc_id = aws_vpc.ecs_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 1880
    to_port = 1880
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # No clue what this does
  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["200.0.0.0/24"]
  }

  egress {
    # allow all traffic to private subnet? I think this just allows outbound to public
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_public_security_group"
    Description = "Managed by Terraform"
  }
}
