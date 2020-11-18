terraform {
 backend "s3" {
    bucket = "mybucket-perovss"
    encrypt        = true
    key    = "main-infra/terraform.tfstate"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
  Name =local.web_instance_type_map[terraform.workspace]
  }
}



data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

