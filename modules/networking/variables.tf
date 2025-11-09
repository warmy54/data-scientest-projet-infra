variable "namespace" {
  type        = string
  description = "Préfixe des ressources"
}

variable "tags" {
  type        = map(string)
  description = "Tags communs"
  default     = {}
}

variable "bastion_allowed_ip" {
  description = "Adresse IP autorisée à se connecter au bastion"
  type        = string
}