variable "region" {
    default = "ap-southeast-2"
}

variable "port" {
    default = "80"
}

variable "protocol" {
    default = "HTTP"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_pair" {
    default = "ec2_key" # ecs-instance
}