output "vpc_id" {
  value = module.networking.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "bucket_name" {
  value = module.s3.bucket_name
}

output "bastion_public_ip" {
  value = module.bastion.bastion_ip
}