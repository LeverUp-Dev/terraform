# Codebuild 역할 생성
resource "aws_iam_role" "codebuild_role" {
  name               = "cicd-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_role.json
}

# Codebuild 역할에 정책 부여
resource "aws_iam_role_policy" "codebuild_role" {
  role   = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

# Codebuild 역할에 기존 정책 연결
resource "aws_iam_role_policy_attachment" "codebuild-attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# codebuild 생성
resource "aws_codebuild_project" "codebuild" {
  name           = "cicd-codebuild"
  description    = "cicd-codebuild"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    privileged_mode = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec = templatefile("${path.module}/buildspec.yaml", {
      account_id = var.account_id
      container_name = "cicd-container"
      project_name = "cicd"
    })
  }
}

# Codebuild 신뢰할 수 있는 엔티티
data "aws_iam_policy_document" "codebuild_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Codebuild 역할 정책
data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/codebuild/cicd-codebuild",
      "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/codebuild/cicd-codebuild:*"
    ]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }

  statement {
    effect = "Allow"
    
    actions = [
      "s3:PutObject",
      "s3:GetObject", 
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    
    resources = [
      "arn:aws:s3:::cicd-bucket-*"
    ]
  }

  statement {
    effect = "Allow"
    
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport", 
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    
    resources = [
      "arn:aws:codebuild:${var.aws_region}:${var.account_id}:report-group/cicd-*"
    ]
  }
}
