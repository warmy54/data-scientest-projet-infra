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
  tags      = var.tags
  bastion_allowed_ip = "54.194.125.82"
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

  enable_irsa = true

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

# Module S3
module "s3" {
  source      = "./modules/s3"
  bucket_name = "${var.namespace}-wordpress-bucket"
  tags        = var.tags
}

# Module Bastion
module "bastion" {
  source           = "./modules/bastion"
  public_subnet_id = module.networking.public_subnets[0]
  sg_id            = module.networking.sg_pub_id
  ami_id           = "ami-0905a3c97561e0b69" # Ubuntu 22.04 eu-west-3
  key_pair_name    = "terraform_key"
  namespace        = var.namespace
}