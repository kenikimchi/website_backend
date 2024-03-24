# KMS keys for encryption

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_kms_key" "encryption_key" {
  description             = "Use this key for encrypting bucket objects"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
  enable_key_rotation     = true
}

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow access for Administrators"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [var.codepipeline_role_arn]
    }
  }

  statement {
    sid    = "Allow attachment for persistent sources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [var.codepipeline_role_arn]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}