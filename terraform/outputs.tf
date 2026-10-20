output "availability_zones" {
  description = "Available AWS Availability Zones in the configured region"
  value       = data.aws_availability_zones.available.names
}

output "lab_vpc_id" {
  description = "ID of the VPC that is created"
  value       = aws_vpc.lab.id
}
