data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "099720109477"]
  # Canonical
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
resource "aws_network_interface" "this" {
  count = 1

  subnet_id = tolist(data.aws_subnet_ids.all.ids)[count.index]
}
module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = "my-cluster"
  instance_count = 1
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  monitoring = true
  subnet_id =tolist(data.aws_subnet_ids.all.ids)[0]
  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "First aws"
  }
}
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

