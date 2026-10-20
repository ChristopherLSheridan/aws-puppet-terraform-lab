variable "aws_region" {
  type        = string
  description = "AWS region for instance"
  default     = "us-east-2"
}
variable "ssh_allowed_cidr" {
  description = "Public IPv4 CIDR allowed to SSH into the instance"
  type        = string
}
