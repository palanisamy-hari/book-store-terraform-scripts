variable "environment" {
  default = "dev"
}

variable "region" {
  default = "us-east-2"
  description = "AWS Instance Region"
}

variable "ami_instance" {
  description = "ami id"
}

variable "ami" {
  type = string
  default = "ami-0b9064170e32bde34"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "zalenium_instance_type" {
  type = string
  default = "t2.micro"
}

variable "cidr_block" {
  type = list(string)
  default = ["172.20.0.0/16", "172.20.10.0/24"]
}

variable "ports" {
  type = list(number)
  default = [22,80,8080,443,8081,9000,4444,5000]
}

variable "public_subnet_cidr" {
  description = "Public Subnet 1 cidr block"
}