variable "bucket_name" {
  description = "O nome do bucket S3"
  type        = string
}

variable "environment" {
  description = "O ambiente de implantação (por exemplo, Dev, Prod)"
  type        = string
  default     = "Dev"
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3"
  type        = string
  default     = "Enabled"
}

variable "role_name" {
  description = "Nome da role IAM para acessar o bucket S3"
  type        = string
  default     = "s3-access-role"
}
