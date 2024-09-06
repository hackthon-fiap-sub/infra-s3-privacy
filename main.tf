# Define o bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# Bloqueio de Acesso Público - Ajuste para permitir políticas públicas, se necessário
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.my_bucket.id
  block_public_acls       = true
  block_public_policy     = false  # Permitir políticas públicas
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Definindo uma política de acesso restrito ao S3 (evitando acesso público)
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.s3_access_role.arn  # Acesso restrito à IAM Role
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}

# Configuração de versionamento do bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = var.versioning_status
  }
}

# Configuração de criptografia no bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.my_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Definindo a role IAM para acessar o bucket S3
resource "aws_iam_role" "s3_access_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"  # Ajuste conforme o serviço necessário
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Define a política com permissões de acesso ao S3
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.role_name}_policy"
  description = "Permissões para gerenciar o bucket S3"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutBucketPolicy"
        ],
        Resource = [
          "${aws_s3_bucket.my_bucket.arn}",
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Anexa a política à role
resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
