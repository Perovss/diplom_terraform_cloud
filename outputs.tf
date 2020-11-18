variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = ""
}
variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}




output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
output "aws_region" {
  value = data.aws_region.current.name
}
output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.web.private_ip
}
output "subnet_id" {
  description = "List of IDs of VPC subnets of instances"
  value       = aws_instance.web.subnet_id
}
output "aws_ami" {
  value =data.aws_ami.ubuntu.name
}