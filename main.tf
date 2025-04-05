provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "app_server" {
  ami           = "ami-0db4215299a464a09"
  instance_type = "t2.micro"
  key_name      = "aws-terraform"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y git httpd
              systemctl start httpd
              systemctl enable httpd
              cd /var/www/html
              git clone git@github.com:ellow0rld/Time-Zone-Converter.git site
              cp -r site/* .
              rm -rf site
            EOF

  tags = {
    Name = "StaticHTMLServer"
  }
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}
