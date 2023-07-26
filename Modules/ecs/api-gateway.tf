
resource "aws_api_gateway_vpc_link" "vpc_link" {
 name        = "${terraform.workspace}-vpc-link"
 target_arns = [ aws_lb.nlb.arn ]
}

resource "aws_api_gateway_rest_api" "apigateway" {
  name        = "${terraform.workspace}-api-gateway"
  description = "API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "user-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "user-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}


# resource "aws_api_gateway_resource" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.apigateway.id
#   parent_id   = aws_api_gateway_resource.user-service.id
#   path_part   = "{proxy+}"
# }
resource "aws_api_gateway_method" "method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.user-service.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "integration" {
  http_method = aws_api_gateway_method.method.http_method
  resource_id = aws_api_gateway_resource.user-service.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:4001/{proxy+}"
  integration_http_method = "ANY"
  # passthrough_behavior    = "WHEN_NO_MATCH"
  # content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}

# Create a deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  # stage_name  = "prod"
}
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  stage_name    = "${terraform.workspace}"
}
