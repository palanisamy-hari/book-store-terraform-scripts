terraform {
  required_version = ">= 0.14"
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_instance" "app_server" {
  ami = var.ami_instance
  instance_type = var.instance_type
  availability_zone = "${var.region}b"
  key_name = "hari-aws"
  subnet_id = aws_subnet.subnet-1.id

  tags = {
    Name = "concourse"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.environment}-Public-Subnet-1"
  }
}