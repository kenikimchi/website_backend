# API Gateway

#Page Count API
resource "aws_apigatewayv2_api" "site_api" {
  name          = var.apigateway_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.cors_allowed_origins
    allow_methods = ["POST", "OPTIONS", "GET"]
    allow_headers = ["content-type"]
  }
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id = aws_apigatewayv2_api.site_api.id

  name        = var.api_stage_name
  auto_deploy = true

  access_log_settings {
    destination_arn = var.apigateway_cwlogs_arn
    format          = var.apigateway_log_format
  }
}

resource "aws_apigatewayv2_integration" "api_integration" {
  api_id               = aws_apigatewayv2_api.site_api.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = var.integration_uri
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.site_api.id
  route_key = "POST /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}

# Bike Station API
resource "aws_apigatewayv2_route" "bikestation_route" {
  api_id    = aws_apigatewayv2_api.site_api.id
  route_key = "GET /bikestation"
  target    = "integrations/${aws_apigatewayv2_integration.bike_station.id}"
}

resource "aws_apigatewayv2_integration" "bike_station" {
  api_id               = aws_apigatewayv2_api.site_api.id
  integration_type     = "HTTP_PROXY"
  integration_method   = "GET"
  integration_uri      = var.bikestation_integration_uri
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "station_location" {
  api_id    = aws_apigatewayv2_api.site_api.id
  route_key = "GET /stationloc"
  target    = "integrations/${aws_apigatewayv2_integration.station_location.id}"
}

resource "aws_apigatewayv2_integration" "station_location" {
  api_id               = aws_apigatewayv2_api.site_api.id
  integration_type     = "HTTP_PROXY"
  integration_method   = "GET"
  integration_uri      = var.station_location_uri
  passthrough_behavior = "WHEN_NO_MATCH"
}

# Permissions
resource "aws_api_gateway_account" "cwlogs_permissions" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "api_gateway_cloudwatch"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cloudwatch" {
  name   = "default"
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}