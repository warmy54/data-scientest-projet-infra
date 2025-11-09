# Projet WebService - Infrastructure

L’infrastructure du projet WebService est provisionnée via Terraform et repose sur une architecture AWS multi-AZ incluant :

- Un réseau (VPC, subnets publics/privés, NAT, IGW)
- Un Load Balancer (ALB)
- Un cluster EKS avec autoscaling
- Une base de données RDS MariaDB en haute disponibilité
- Des outils de monitoring et de gestion de secrets (Prometheus, Vault, ArgoCD)



## Structure du projet
```
.
├── modules/
│   ├── networking/
│   ├── eks/
│   └── rds/
├── envs/
│   ├── dev/
│   └── prod/
├── main.tf
├── variables.tf
├── outputs.tf
└── install_wordpress.sh
```
