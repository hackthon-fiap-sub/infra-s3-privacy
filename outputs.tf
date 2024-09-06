output "bucket_id" {
  description = "O ID do bucket S3"
  value       = aws_s3_bucket.my_bucket.id
}

output "bucket_arn" {
  description = "O ARN do bucket S3"
  value       = aws_s3_bucket.my_bucket.arn
}

output "s3_access_role_arn" {
  description = "ARN da role IAM criada para acesso ao S3"
  value       = aws_iam_role.s3_access_role.arn
}