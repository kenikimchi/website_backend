# S3
domain_name         = "kendrickkim.com"
pipeline_bucket     = "kendrickkim-pipelinebucket"
lambda_dependencies = "kendrickkim-lambdadependencies"
tf_bucket_name      = "kendrickkim-tfstate"
logging_bucket_name = "kendrickkim-pipeline-logs"

# CLoudFront
site_aliases              = ["www.kendrickkim.com"]
price_class               = "PriceClass_100"
origin_access_type        = "s3"
geo_restriction_locations = ["US"]
root_object               = "home"

# CodeBuild
artifacts_type              = "CODEPIPELINE"
environment_compute_type    = "BUILD_GENERAL1_SMALL"
environment_image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
environment_type            = "LINUX_CONTAINER"
image_pull_credentials_type = "CODEBUILD"
source_type                 = "CODEPIPELINE"
source_location             = "https://github.com/kenikimchi/website_backend"
build_stages                = ["validate", "plan", "apply", "destroy"]
codebuild_policy_name       = "kendrickkim_codebuild_policy"
codebuild_iam_role_name     = "kendrickkim_codebuild_role"

# CodePipeline
project_name = "tf-website"
full_repo_id = "kenikimchi/website_backend"
stages = [
  { name = "validate", category = "Test", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "validate_output" },
  { name = "plan", category = "Test", owner = "AWS", provider = "CodeBuild", input_artifacts = "validate_output", output_artifacts = "plan_output" },
  { name = "apply", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "plan_output", output_artifacts = "apply_output" },
]
codepipeline_iam_role_name = "kendrickkim_codepipeline_role"
branch_name                = "main"
source_provider            = "CodeStarSourceConnection"

# CodeCommit
source_repo_name   = "website-backend"
source_repo_branch = "main"
repo_approvers_arn = "arn:aws:iam::027975384119:user/admin-general"

# DynamoDB
tfstate_table_name = "tf-statelock"

# CloudWatch
pipeline_log_group_name  = "kendrickkim-codepipeline-loggroup"
pipeline_log_stream_name = "kendrickkim-codepipeline-logstream"
apigateway_group_name = "kendrickkim-apigateway-loggroup"

# Lambda
lambda_function_name = "dynamodb_writer"

# API Gateway
apigateway_name      = "site_gateway"
api_stage_name       = "prod"
cors_allowed_origins = ["https://www.kendrickkim.com"]