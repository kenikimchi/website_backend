# Lambda Functions

data "archive_file" "lambda_writer_function" {
  type = "zip"

  source_dir  = "${path.module}/functions/code"
  output_path = "${path.module}/functions/payload.zip"
}

# Upload archive to s3
resource "aws_s3_object" "lambda_writer_function" {
  bucket = var.dependencies_bucket
  key    = "payload.zip"
  source = data.archive_file.lambda_writer_function.output_path
}

resource "aws_lambda_function" "db_writer" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_assume_role.arn
  s3_bucket     = var.dependencies_bucket
  s3_key        = "payload.zip"
  handler       = "dbWriter.lambda_handler"
  runtime       = "python3.12"

  layers = [aws_lambda_layer_version.dependencies.arn]
}

resource "aws_lambda_layer_version" "dependencies" {
  layer_name          = "lambda_dependencies"
  compatible_runtimes = ["python3.12"]
  s3_bucket           = var.dependencies_bucket
  s3_key              = "lambda_layer.zip"
}

# Permissions
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.db_writer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_execution_arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_assume_role" {
  name               = "lambda_assum_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "lambdaPolicy" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:UpdateItem"]
    resources = var.pagecount_database
  }
}

resource "aws_iam_policy" "lambdaIamPolicy" {
  name   = "lambdaIamPolicy"
  policy = data.aws_iam_policy_document.lambdaPolicy.json
}

resource "aws_iam_role_policy_attachment" "lambda_attachments" {
  role       = aws_iam_role.lambda_assume_role.name
  policy_arn = aws_iam_policy.lambdaIamPolicy.arn
}