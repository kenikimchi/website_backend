
# Terraform Pipeline
resource "aws_codepipeline" "terraform_pipeline" {

  name     = "${var.project_name}-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = var.pipeline_bucket_id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Download-Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = var.source_provider
      namespace        = "SourceVariables"
      output_artifacts = ["source_output"]
      run_order        = 1

      configuration = {
        FullRepositoryId     = var.full_repo_id
        BranchName           = var.branch_name
        ConnectionArn        = var.codestarconnection_github_arn
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  dynamic "stage" {
    for_each = var.stages

    content {
      name = "Stage-${stage.value["name"]}"
      action {
        category         = stage.value["category"]
        name             = "Action-${stage.value["name"]}"
        owner            = stage.value["owner"]
        provider         = stage.value["provider"]
        input_artifacts  = [stage.value["input_artifacts"]]
        output_artifacts = [stage.value["output_artifacts"]]
        version          = "1"
        run_order        = index(var.stages, stage.value) + 2

        configuration = {
          ProjectName = stage.value["provider"] == "CodeBuild" ? "${var.project_name}-${stage.value["name"]}" : null
        }
      }
    }
  }
}

# Permissions
data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "pipeline_role" {
  name               = var.codepipeline_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

data "aws_iam_policy_document" "pipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*"
    ]

    resources = ["${var.pipeline_bucket_arn}./", var.pipeline_bucket_arn]
  }


  statement {
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt"
    ]

    resources = [var.kms_key_arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush",
      "codecommit:GetBranch",
      "codecommit:CreateCommit",
      "codecommit:ListRepositories",
      "codecommit:BatchGetCommits",
      "codecommit:BatchGetRepositories",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:ListBranches",
      "codecommit:UploadArchive"
    ]

    resources = ["arn:aws:codecommit:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:${var.source_repository_name}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetProjects"
    ]

    resources = ["arn:aws:codebuild:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:project/${var.project_name}*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases"
    ]

    resources = ["arn:aws:codebuild:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:report-group/${var.project_name}*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:*"]
  }

  statement {
    effect = "Allow"

    actions   = ["codestar-connections:UseConnection"]
    resources = [var.codestarconnection_github_arn]
  }
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name   = "pipeline_policy"
  role   = aws_iam_role.pipeline_role.id
  policy = data.aws_iam_policy_document.pipeline_policy.json
}