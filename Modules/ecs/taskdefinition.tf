#Task definition UAT User Service
resource "aws_ecs_task_definition" "onchain_user_service" {
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
        "containerPort": 4001,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/onchain-user-service",
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

#Task definition UAT Poll Service
resource "aws_ecs_task_definition" "onchain_poll_service" {
  family                = "${terraform.workspace}-poll"
 # network_mode             = var.task_network_mode
  container_definitions = <<DEFINITION
[
  {
    "name": "${terraform.workspace}-poll",
    "image": "${var.poll_image}",
    "command": ["/bin/sh", "-c", "npm run migration:run && npm run pm2"],
    "portMappings": [
      {
        "containerPort": 4002,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/onchain-poll-service",
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
resource "aws_ecs_task_definition" "onchain_reward_service" {
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
        "containerPort": 4004,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/onchain-reward-service",
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

#Task definition UAT BlockChain Service
resource "aws_ecs_task_definition" "onchain_blockchain_service" {
  family                = "${terraform.workspace}-blockchain"
  #network_mode             = var.task_network_mode
  container_definitions = <<DEFINITION
[
  {
    "name": "${terraform.workspace}-blockchain",
    "image": "${var.blockchain_image}",
    "command": ["/bin/sh", "-c", "npm run pm2"],
    "portMappings": [
      {
        "containerPort": 4003,
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
        "awslogs-group": "/ecs/onchain-blockchain-service",
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