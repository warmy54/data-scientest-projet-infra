# Récupère les infos du cluster créé par le module EKS
data "aws_eks_cluster" "eks_cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = module.eks.cluster_name
}

# Provider Kubernetes pointant vers EKS
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_auth.token
}

# Provider Helm branché sur le même cluster
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_auth.token
  }
}