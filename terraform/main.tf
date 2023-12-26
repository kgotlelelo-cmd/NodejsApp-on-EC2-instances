terraform {
  required_version = "1.6.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source = "./modules/vpc"
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "application" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = module.vpc.subnet-id

  user_data = <<-EOF
    #!/bin/bash
    # Update package lists and install Node.js
    sudo apt-get update -y
    sudo apt-get install -y nodejs npm
  EOF

  tags = {
    Name = "Appliication"
  }
}