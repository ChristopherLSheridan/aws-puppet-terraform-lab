data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "lab" {
  cidr_block = "10.50.0.0/16"

  tags = {
    Name        = "terraform-gitops-lab"
    Environment = "development"
    Project     = "aws-terraform-gitops-lab"
  }
}
