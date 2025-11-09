variable "namespace" {
  description = "Préfixe des ressources AWS"
  type        = string
  default     = "datascientest"
}

variable "region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default = {
    Projet = "projet-infra"
  }
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}