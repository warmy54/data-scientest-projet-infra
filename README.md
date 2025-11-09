# Projet WebService - Infrastructure

L’infrastructure du projet WebService est provisionnée via Terraform et repose sur une architecture AWS multi-AZ incluant :

L’infrastructure du projet WebService est provisionnée avec Terraform sur AWS.  
Elle repose sur une architecture multi-AZ hautement disponible, incluant :

- Un réseau complet (VPC, subnets publics/privés, NAT Gateway, Internet Gateway)  
- Un ALB (Load Balancer) pour exposer l'application  
- Un cluster EKS réparti sur plusieurs zones  
- Autoscaling via Karpenter (va être ajouté ensuite)  
- Une base de données RDS MariaDB en haute disponibilité  
- Un bucket S3 pour les fichiers WordPress  
- Une instance Bastion pour l’accès SSH sécurisé  
- Une configuration Kubernetes (Ingress, ServiceAccount, IAM) prête pour déployer WordPress  
- Outils de monitoring et gestion de secrets prévus : Prometheus, Vault, ArgoCD  




## Structure du projet
```
.
├── README.md
├── envs
│   ├── dev
│   └── prod
├── install_wordpress.sh
├── k8s
│   ├── ingress-helm.tf
│   ├── ingress-iam.tf
│   ├── ingress-sa.tf
│   └── ingress-wordpress.tf
├── main.tf
├── modules
│   ├── bastion
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── networking
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── rds
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── s3
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── providers-k8s.tf
├── terraform.tfstate
├── terraform.tfvars
└── variables.tf
```

Voici une section simple, propre et claire à ajouter dans ton README :

⸻


## Déploiement de l’infrastructure

Prérequis:
- Terraform ≥ 1.3 installé
- Un utilisateur AWS avec les permissions nécessaires (VPC, EC2, EKS, IAM, RDS, S3)

terraform init
terraform validate
terraform plan
terraform apply

## Destruction de l’infrastructure

terraform destroy

## Remarques
	•	Si l’IP publique change, il faut mettre à jour l’accès SSH du Bastion

