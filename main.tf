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
locals {web_instance_type_map = {
  stage = "t3.micro"
  prod = "t3.large"}}
locals {web_instance_count = {
  stage = 1
  prod = 2
}}

resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count[terraform.workspace]
  tags = {
  Name =local.web_instance_type_map[terraform.workspace]
  }
}
locals {instances = {
  "t3.micro" = data.aws_ami.ubuntu.id
  "t3.large" = data.aws_ami.ubuntu.id
}}
resource "aws_instance" "panorama" {
  for_each = local.instances
  ami = each.value
  instance_type = each.key

  tags = {
  Name =data.aws_ami.ubuntu.image_type
  }
  lifecycle {create_before_destroy = true}

}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

