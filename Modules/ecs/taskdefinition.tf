#Task definition UAT auth Service
resource "aws_ecs_task_definition" "gomeme_auth_service" {
  family                = "${terraform.workspace}-auth"
 # network_mode             = var.task_network_mode
  container_definitions = <<DEFINITION
[
  {
    "name": "${terraform.workspace}-auth",
    "image": "${var.auth_image}",
    "command": ["/bin/sh", "-c", "npm run migration:run && npm run pm2"],
    "portMappings": [
      {
        "containerPort": 5010,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/gomeme-auth-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      },
    "memory": 512,
    "cpu": 256
  }
  
]
DEFINITION

  execution_role_arn = aws_iam_role.task-definition-role.arn
}

#Task definition UAT cms Service
resource "aws_ecs_task_definition" "gomeme_cms_service" {
  family                = "${terraform.workspace}-cms"
 # network_mode             = var.task_network_mode
  container_definitions = <<DEFINITION
[
  {
    "name": "${terraform.workspace}-cms",
    "image": "${var.cms_image}",
    "command": ["/bin/sh", "-c", "npm run migration:run && npm run pm2"],
    "portMappings": [
      {
        "containerPort": 5050,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/gomeme-cms-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      },
    "memory": 512,
    "cpu": 256
  }
  
]
DEFINITION

  execution_role_arn = aws_iam_role.task-definition-role.arn
}

#Task definition UAT Reward Service
resource "aws_ecs_task_definition" "gomeme_reward_service" {
  family                = "${terraform.workspace}-reward"
  #network_mode             = var.task_network_mode
  container_definitions = <<DEFINITION
[
  {
    "name": "${terraform.workspace}-reward",
    "image": "${var.reward_image}",
    "command": ["/bin/sh", "-c", "npm run migration:run && npm run pm2"],
    "portMappings": [
      {
        "containerPort": 5040,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/gomeme-reward-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      },
    "memory": 512,
    "cpu": 256
  }
  
]
DEFINITION

  execution_role_arn = aws_iam_role.task-definition-role.arn
}

#Task definition UAT notification Service
resource "aws_ecs_task_definition" "gomeme_notification_service" {
  family                = "${terraform.workspace}-notification"
  #network_mode             = var.task_network_mode
  container_definitions = <<DEFINITION
[
  {
    "name": "${terraform.workspace}-notification",
    "image": "${var.notification_image}",
    "command": ["/bin/sh", "-c", "npm run pm2"],
    "portMappings": [
      {
        "containerPort": 5020,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/gomeme-notification-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      },
    "memory": 512,
    "cpu": 256
  }
  
]
DEFINITION

  execution_role_arn = aws_iam_role.task-definition-role.arn
}

#Task definition UAT User Service
resource "aws_ecs_task_definition" "gomeme_user_service" {
  family                = "${terraform.workspace}-user"
 # network_mode             = var.task_network_mode
  container_definitions = <<DEFINITION
[
  {
    "name": "${terraform.workspace}-user",
    "image": "${var.user_image}",
    "command": ["/bin/sh", "-c", "npm run migration:run && npm run pm2"],
    "portMappings": [
      {
        "containerPort": 5030,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/gomeme-user-service",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
        }
      },
    "memory": 512,
    "cpu": 256
  }
  
]
DEFINITION

  execution_role_arn = aws_iam_role.task-definition-role.arn
}
