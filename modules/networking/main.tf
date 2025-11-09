terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39"
    }
  }
}
# récupère dynamiquement les zones de disponibilité
data "aws_availability_zones" "available" {}

# appel du module vpc depuis le registry Terraform
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  name    = "${var.namespace}-vpc"
  cidr    = "10.0.0.0/16"

  azs = data.aws_availability_zones.available.names

  # Subnets publics (Load Balancer, accès externe)
  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  # Subnets privés (EKS nodes)
  private_subnets = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]

  # Subnets dédiés RDS
  database_subnets = [
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  tags = merge(var.tags, {
    Name = "${var.namespace}-vpc"
  })

}

# SG public : accès depuis Internet
resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.namespace}-allow_ssh_pub"
  description = "Autoriser SSH et HTTP depuis Internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH depuis Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP depuis Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.namespace}-allow_ssh_pub"
  })


}

# SG privé : accès interne uniquement
resource "aws_security_group" "allow_ssh_priv" {
  name        = "${var.namespace}-allow_ssh_priv"
  description = "Autoriser SSH et HTTP interne VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH interne"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "HTTP interne"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.namespace}-allow_ssh_priv"
  })

}

#SG Bastion
resource "aws_security_group" "bastion" {
  name   = "${var.namespace}-bastion-sg"
  vpc_id = module.vpc.vpc_id
  

  ingress {
    description = "SSH depuis ton IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_allowed_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.namespace}-bastion-sg"
  })
}