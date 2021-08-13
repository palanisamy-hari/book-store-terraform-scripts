resource "aws_instance" "blue" {
  count = var.enable_blue_env ? var.blue_instance_count : 0

  ami                    = var.ami
  instance_type          = "t2.micro"
  key_name               = "hari-aws-key"
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [module.app_security_group.this_security_group_id]
  user_data = templatefile("${path.module}/start-node-js-app.sh", {
    file_content = "version 1.0 - #${count.index}"
  })

  tags = {
    Name = "blue-1-${count.index}"
  }

  provisioner "file" {
    source = "./start-node-js-app.sh"
    destination = "/tmp/start-node-js-app.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/start-node-js-app.sh",
      "/tmp/start-node-js-app.sh ${self.public_ip}",
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("hari-aws-key.pem")
    host = self.public_ip
  }

}

resource "aws_lb_target_group" "blue" {
  name     = "blue-tg-${random_pet.app.id}-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "blue" {
  count            = length(aws_instance.blue)
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = aws_instance.blue[count.index].id
  port             = 80
}