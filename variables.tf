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