resource "aws_apigatewayv2_api" "apigw" {
  name          = local.api_gateway_name
  protocol_type = "HTTP"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "8b6589ff-86c6-4ee4-a688-dd582eecb8d0"
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = aws_apigatewayv2_api.apigw.id
  integration_type = "AWS_PROXY"

  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = module.lambda_function_container_image.lambda_function_invoke_arn
  payload_format_version = "1.0"
  passthrough_behavior   = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "main_route" {
  api_id             = aws_apigatewayv2_api.apigw.id
  route_key          = "POST ${local.api_gateway_route}"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  request_parameter {
    request_parameter_key = "route.request.header.Authorization"
    required              = false
  }
}

resource "aws_apigatewayv2_deployment" "example" {
  api_id      = aws_apigatewayv2_route.main_route.api_id
  description = "Main deployment"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id        = aws_apigatewayv2_api.apigw.id
  deployment_id = aws_apigatewayv2_deployment.example.id
  name          = "prod"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "44fb225a-b00c-4f0e-9b20-ec8a750b0dbb"
  }
}