# API Gateway

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
  target    = "integration/${aws_apigatewayv2_integration.api_integration.id}"
}