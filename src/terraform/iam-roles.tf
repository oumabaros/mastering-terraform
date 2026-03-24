resource "aws_iam_role" "backend" {
  name = "${var.application_name}-${var.environment_name}-iam-role-ec2-backend"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },

    ]
  })
}

resource "aws_iam_role_policy" "backend" {
  name = "${var.application_name}-${var.environment_name}-iam-role-policy-ec2-backend"
  role = aws_iam_role.backend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:secret:${var.application_name}/${var.environment_name}/*"
      },
      {
        Action = [
          "s3:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "backend_profile" {
  name = "${var.application_name}-${var.environment_name}-iam-instance-profile-ec2-backend"
  role = aws_iam_role.backend.name
}


