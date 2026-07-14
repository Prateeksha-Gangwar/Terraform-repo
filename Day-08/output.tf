output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.name.id
}

output "subnet_id" {
  description = "ID of the created subnet."
  value       = aws_subnet.name.id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway."
  value       = aws_internet_gateway.name.id
}

output "route_table_id" {
  description = "ID of the route table."
  value       = aws_route_table.name.id
}

output "security_group_id" {
  description = "ID of the security group."
  value       = aws_security_group.name.id
}

output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.name.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.name.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance."
  value       = aws_instance.name.private_ip
}
