
resource "aws_key_pair" "deployer" {
  key_name   = "erick-lab-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "allow-web" {
  name        = "allow_web_traffic"
  description = "Allows web and ssh traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

resource "aws_instance" "web-server" {
  ami                    = "ami-0f9c27b471bdcd702"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-web.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
  #!/bin/bash
  apt-get update
  apt-get install nginx -y
  echo "<h1>Hello Erick! This VM was built with Terraform and Auto-Configured.</h1>" | tee /var/www/html/index.html
  systemctl restart nginx
  EOF

  tags = {
    name = "Erick-aws-terraform-lab"
  }
}

output "vm-name" {
  value       = aws_instance.web-server.tags.name
  description = "vm name"
}
output "vm-public-ip" {
  value       = aws_instance.web-server.public_ip
  description = "vm public ip"
}
output "vm-region" {
  value       = aws_instance.web-server.region
  description = "vm region"
}
