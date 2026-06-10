provider "aws" {
  region = "ap-south-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group for SSH and HTTP
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-SG"
  }
}

# EC2 Instance
resource "aws_instance" "ec2_example" {
  ami           = "ami-0db56f446d44f2f09"
  instance_type = "t2.micro"
  key_name      = "lipi-key"
  subnet_id     = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "Terraform-EC2"
  }
}

