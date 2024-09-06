provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "A região AWS onde os recursos serão criados"
  default     = "us-east-1"
}
