
# Latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Register existing SSH public key with AWS
resource "aws_key_pair" "lab" {
  key_name   = "terraform-gitops-lab"
  public_key = file("${path.module}/keys/lab.pub")

  tags = {
    Name        = "terraform-gitops-lab"
    Environment = "development"
    Project     = "aws-terraform-gitops-lab"
  }
}

# Allow SSH from your approved IP and HTTP traffic
resource "aws_security_group" "web" {
  name        = "terraform-gitops-web"
  description = "Security group for GitOps lab"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "SSH from ThinkPad network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "terraform-gitops-web"
    Environment = "development"
    Project     = "aws-terraform-gitops-lab"
  }
}

# Ubuntu instance for Ansible configuration
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = aws_key_pair.lab.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
  }

  tags = {
    Name        = "terraform-gitops-web"
    Environment = "development"
    Project     = "aws-terraform-gitops-lab"
  }
}
