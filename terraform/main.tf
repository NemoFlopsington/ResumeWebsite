terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "frontend_key" {
  key_name   = "frontend-key"
  public_key = var.public_key
}

resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow SSH and application traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0.0.0.0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0.0.0.0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0.0.0.0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0.0.0.0"]
  }
}

resource "aws_instance" "frontend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.frontend_key.key_name
  vpc_security_group_ids     = [aws_security_group.frontend_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
set -euo pipefail

apt-get update
apt-get install -y ca-certificates curl gnupg git
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
printf 'deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main\n' > /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install -y nodejs
npm install -g pm2

cd /home/ubuntu
rm -rf /home/ubuntu/myWebsite
git clone -b ${var.branch} ${var.repository_url} /home/ubuntu/myWebsite
cd /home/ubuntu/myWebsite/FrontEnd
npm install
npm run build

cat > /etc/systemd/system/frontend.service <<SERVICE
[Unit]
Description=Next.js frontend
After=network.target

[Service]
WorkingDirectory=/home/ubuntu/myWebsite/FrontEnd
Environment=PORT=3000
ExecStart=/usr/bin/npm run start
Restart=always
User=ubuntu
Group=ubuntu
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable frontend
systemctl start frontend
EOF

  tags = {
    Name = "frontend-ec2"
  }
}

output "instance_public_ip" {
  value = aws_instance.frontend.public_ip
}

variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.small"
}

variable "public_key" {
  description = "Public SSH key to attach to the EC2 instance"
  type        = string
}

variable "repository_url" {
  description = "GitHub repository URL to deploy"
  type        = string
}

variable "branch" {
  description = "Git branch to deploy"
  type        = string
  default     = "main"
}
