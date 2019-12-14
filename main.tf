# Terraform state will be stored in S3
#terraform {
#  backend "s3" {
#    bucket = "mywebsitebucket-bashsh"
#    key    = "terraform.tfstate"
#    region = "us-east-1"
#  }
#}

# Use AWS Terraform provider
provider "aws" {
  region = "us-east-1"
}

# Create EC2 instance
resource "aws_instance" "default" {
  ami                    = "${var.ami}"
  count                  = "${var.count}"
  # key_name               = "terraform"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  source_dest_check      = false
  instance_type          = "${var.instance_type}"
  user_data              = <<-EOF
                            #!/bin/bash
                           yum install httpd -y
                           echo "Welcome to Apache Server" > /var/www/html/index.html
                           yum update -y
                           service httpd start
                           EOF

  tags {
    Name = "terraform"
  }
}

# Create Security Group for EC2
resource "aws_security_group" "default" {
  name = "terraform-default-sg"

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

}
