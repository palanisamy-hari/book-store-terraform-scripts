#configure the provider & required plugings
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}
#create VPC
resource "aws_vpc" "lab-vpc" {
  cidr_block = var.cidr_block[0]
  tags = {
    Name = "lab-vpc"
  }
}

#create public subnet
resource "aws_subnet" "lab-subnet1" {
  vpc_id = aws_vpc.lab-vpc.id
  cidr_block = var.cidr_block[1]
  tags = {
    "Name" = "lab-subnet1"
  }
}

#configure the IGW
resource "aws_internet_gateway" "lab-igw" {
  vpc_id = aws_vpc.lab-vpc.id
  tags = {
    "Name" = "lab-igw"
  }
}


resource "aws_security_group" "lab-sg" {
  name = "Lab Security Group"
  description = "To allow inbound and outbound traffic to mylab"
  vpc_id = aws_vpc.lab-vpc.id

  dynamic ingress {
    iterator = port
    for_each = var.ports
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "lab-sg"
  }
}


resource "aws_route_table" "lab-rt" {
  vpc_id = aws_vpc.lab-vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-igw.id
  }

  tags = {
    "Name" = "lab-rt"
  }
}

resource "aws_route_table_association" "lab-rt-assoc" {
  subnet_id = aws_subnet.lab-subnet1.id
  route_table_id = aws_route_table.lab-rt.id
}

resource "aws_instance" "concourse-web" {
  ami           = var.ami
  instance_type = var.instance_type_medium
  key_name = "hari-aws-key"
  vpc_security_group_ids = [aws_security_group.lab-sg.id]
  subnet_id = aws_subnet.lab-subnet1.id
  associate_public_ip_address = true

  provisioner "file" {
    source = "./install-concourse.sh"
    destination = "/tmp/install-concourse.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-concourse.sh",
      "/tmp/install-concourse.sh ${self.public_ip}",
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("hari-aws-key.pem")
    host = self.public_ip
  }

  tags = {
    Name = "concourse-web"
  }
}

resource "aws_instance" "zalenium-grid" {
  ami           = var.ami
  instance_type = var.instance_type_custom
  key_name = "hari-aws-key"
  vpc_security_group_ids = [aws_security_group.lab-sg.id]
  subnet_id = aws_subnet.lab-subnet1.id
  associate_public_ip_address = true

  provisioner "file" {
    source = "./install-zalenium-grid.sh"
    destination = "/tmp/install-zalenium-grid.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-zalenium-grid.sh",
      "/tmp/install-zalenium-grid.sh ${self.public_ip}",
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("hari-aws-key.pem")
    host = self.public_ip
  }

  tags = {
    Name = "zalenium-grid"
  }
}


resource "aws_instance" "sonarqube" {
  ami           = var.ami
  instance_type = var.instance_type_custom
  key_name = "hari-aws-key"
  vpc_security_group_ids = [aws_security_group.lab-sg.id]
  subnet_id = aws_subnet.lab-subnet1.id
  associate_public_ip_address = true

  provisioner "file" {
    source = "./install-sonarqube.sh"
    destination = "/tmp/install-sonarqube.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-sonarqube.sh",
      "/tmp/install-sonarqube.sh ${self.public_ip}",
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("hari-aws-key.pem")
    host = self.public_ip
  }

  tags = {
    Name = "sonarqube"
  }
}