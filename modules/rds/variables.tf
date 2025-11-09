# environnement de déploiement
variable "namespace" {
  type = string
}

# liste des subnets privés
variable "subnet_ids" {
  type = list(string)
}

# SG RDS
variable "vpc_security_group_ids" {
  type = list(string)
}

# utilisateur et mot de passe BD
variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

# tags
variable "tags" {
  type = map(string)
}