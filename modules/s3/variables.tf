variable "bucket_name" {
  description = "Nom du bucket S3 pour les fichiers WordPress"
  type        = string
}

variable "tags" {
  description = "Tags communs"
  type        = map(string)
}