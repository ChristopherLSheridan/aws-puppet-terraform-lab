output "availability_zones" {
  description = "Available AWS Availability Zones in the configured region"
  value       = data.aws_availability_zones.available.names
}
