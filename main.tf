terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
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
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "${var.namespace}-eks"
  cluster_version = "1.28"

  vpc_id     = module.networking.vpc.vpc_id
  subnet_ids = module.networking.vpc.private_subnets

  eks_managed_node_groups = {
    workers = {
      desired_size   = 2
      min_size       = 1
      max_size       = 2
      instance_types = ["t3.small"]
    }
  }
  tags = merge(var.tags, {
    Terraform = "true"
    Environ   = var.namespace
  })
}



# Module RDS
module "rds" {
  source     = "./modules/rds"
  namespace  = var.namespace
  subnet_ids = module.networking.private_subnets

  vpc_security_group_ids = [module.networking.sg_priv_id]

  db_username = var.db_username
  db_password = var.db_password

  tags = {
    Projet = var.namespace
  }
}