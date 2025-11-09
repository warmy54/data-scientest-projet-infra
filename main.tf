terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Module réseau
module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

# Module EKS
module "eks" {
  source     = "./modules/eks"
  namespace  = var.namespace
  vpc_id     = module.networking.vpc_id
  subnets    = module.networking.private_subnets
}

# Module RDS
module "rds" {
  source     = "./modules/rds"
  namespace  = var.namespace
  subnet_ids = module.networking.private_subnets
  vpc_id     = module.networking.vpc_id
}