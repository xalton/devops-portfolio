provider "aws" {
  region = "eu-west-3"
}

variable "instance_name" {
  description = "Nom de la VM"
  type        = string
  default     = "portfolio-instagram-tracker"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "my_ip" {
  description = "Mon IP publique, pour restreindre l'accès SSH"
  type        = string
  default     = "81.243.28.211/32"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh-from-me"
  description = "Autorise uniquement SSH depuis mon IP publique"

  ingress {
    description = "SSH depuis mon IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Tout le trafic sortant autorisé"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-from-me"
  }
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0b4c0d9eb868d7022"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = var.instance_name
  }
}

output "instance_public_ip" {
  description = "Adresse IP publique de la VM"
  value       = aws_instance.web_server.public_ip
}