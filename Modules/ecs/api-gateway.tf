
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
################################################################3
resource "aws_api_gateway_resource" "auth-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "auth-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "auth-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.auth-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "auth-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.auth-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "auth-integration" {
  http_method = aws_api_gateway_method.auth-method.http_method
  resource_id = aws_api_gateway_resource.auth-proxy.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:5010/{proxy+}"
  integration_http_method = "ANY"
  # passthrough_behavior    = "WHEN_NO_MATCH"
  # content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}
#################################################################
resource "aws_api_gateway_resource" "notification-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "notification-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "notification-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.notification-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "notification-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.notification-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "notification-integration" {
  http_method = aws_api_gateway_method.notification-method.http_method
  resource_id = aws_api_gateway_resource.notification-proxy.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:5020/{proxy+}"
  integration_http_method = "ANY"
  # passthrough_behavior    = "WHEN_NO_MATCH"
  # content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}

#################################################################
resource "aws_api_gateway_resource" "user-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "user-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "user-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.user-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "user-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.user-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "user-integration" {
  http_method = aws_api_gateway_method.user-method.http_method
  resource_id = aws_api_gateway_resource.user-proxy.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:5030/{proxy+}"
  integration_http_method = "ANY"
  # passthrough_behavior    = "WHEN_NO_MATCH"
  # content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}
#################################################################
resource "aws_api_gateway_resource" "reward-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "reward-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "reward-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.reward-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "reward-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.reward-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "reward-integration" {
  http_method = aws_api_gateway_method.reward-method.http_method
  resource_id = aws_api_gateway_resource.reward-proxy.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:5040/{proxy+}"
  integration_http_method = "ANY"
  # passthrough_behavior    = "WHEN_NO_MATCH"
  # content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}
#################################################################
resource "aws_api_gateway_resource" "cms-service" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "cms-service"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_resource" "cms-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.cms-service.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "cms-method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.cms-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "cms-integration" {
  http_method = aws_api_gateway_method.cms-method.http_method
  resource_id = aws_api_gateway_resource.cms-proxy.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_lb.nlb.dns_name}:5050/{proxy+}"
  integration_http_method = "ANY"
  # passthrough_behavior    = "WHEN_NO_MATCH"
  # content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpc_link.id

}
#######################################################333333
# Create a deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.auth-integration, aws_api_gateway_integration.user-integration, aws_api_gateway_integration.notification-integration,  aws_api_gateway_integration.reward-integration, aws_api_gateway_integration.cms-integration ]
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  # stage_name
}
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  stage_name    = "${terraform.workspace}"
}
