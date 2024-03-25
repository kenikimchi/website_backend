# CodeCommit

# GitHub Connection
resource "aws_codestarconnections_connection" "GitHub" {
  name          = "GitHub"
  provider_type = "GitHub"
}

resource "aws_codecommit_repository" "source_repository" {
  repository_name = var.source_repository_name
  default_branch  = var.source_repository_branch
  description     = "Code Repository for hosting the terraform code and pipeline configuration files"
}
resource "aws_codecommit_approval_rule_template" "source_repository_approval" {
  name        = "${var.source_repository_name}-${var.source_repository_branch}-Rule"
  description = "Approval rule template for enabling approval process"

  content = <<EOF
{
    "Version": "2018-11-08",
    "DestinationReferences": ["refs/heads/${var.source_repository_branch}"],
    "Statements": [{
        "Type": "Approvers",
        "NumberOfApprovalsNeeded": 1,
        "ApprovalPoolMembers": ["${var.repo_approvers_arn}"]
    }]
}
EOF
}

resource "aws_codecommit_approval_rule_template_association" "source_repository_approval_association" {
  approval_rule_template_name = aws_codecommit_approval_rule_template.source_repository_approval.name
  repository_name             = aws_codecommit_repository.source_repository.repository_name
}