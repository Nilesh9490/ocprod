# cluster
resource "aws_ecs_cluster" "onchain" {
  name = "${terraform.workspace}-cluster"
}

#ECS Launch Configuration
resource "aws_launch_configuration" "ecs-launchconfig" {
  name                 = "${terraform.workspace}-ecs-launchconfig"
  image_id             = var.ecs_ami_id
  instance_type        = var.ecs_instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.name
  security_groups      = [aws_security_group.ecs-launchconfig-sg.id]
  #associate_public_ip_address  = true
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=${terraform.workspace}-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_size = 50 // Specify the desired volume size in GB
    // Other volume configuration options can be added here
  }
}

# ECS AutoScaling
resource "aws_autoscaling_group" "ecs-autoscaling" {
  name                 = "${terraform.workspace}-ecs-autoscaling"
  vpc_zone_identifier  = var.private_subnets
  launch_configuration = aws_launch_configuration.ecs-launchconfig.name
  min_size             = 1
  max_size             = 2

  tag {
    key                 = "Name"
    value               = "ecs-ec2-container"
    propagate_at_launch = true
  }
}

# Network Load Balancer (NLB)
resource "aws_lb" "nlb" {
  name               = "${terraform.workspace}-nlb"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id = element(var.private_subnets, 0)
  }
  subnet_mapping {
    subnet_id = element(var.private_subnets, 1)
  }
  subnet_mapping {
    subnet_id = element(var.private_subnets, 2)
  }

  tags = {
    Name = "${terraform.workspace}-nlb"
  }
}

#ELB Target Group for User Service
resource "aws_lb_target_group" "nlb-user-target-group" {
  name        = "${terraform.workspace}-user-target-group"  
  port        = 4001
  protocol    = "TCP"
  vpc_id      = var.vpc_id
 # target_type = var.nlb_target_type

  health_check {
    path                = "/user-api/api-docs/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

#ELB User Service Listener
resource "aws_lb_listener" "user-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 4001
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-user-target-group.arn
    type             = "forward"
  }
}


# ECS User Service
resource "aws_ecs_service" "onchain-user-service" {
  name                      = "${terraform.workspace}-user-service"
  cluster                   = aws_ecs_cluster.onchain.id
  task_definition           = aws_ecs_task_definition.onchain_user_service.arn
  desired_count             = 1
  #iam_role                  = aws_iam_role.ecs-service-role.arn

  # network_configuration {
  #   subnets          = var.private_subnets
  #   security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
  #   assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  # }

  load_balancer {
    target_group_arn         = aws_lb_target_group.nlb-user-target-group.arn
    container_name           = "${terraform.workspace}-user"
    container_port           = 4001
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

##################################################

#ELB Target Group for Poll Service
resource "aws_lb_target_group" "nlb-poll-target-group" {
  name        = "${terraform.workspace}-poll-target-group"  
  port        = 4002
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  #target_type = var.nlb_target_type

  health_check {
    path                = "/poll-api/v1/health-check"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "nlb-poll-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 4002
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-poll-target-group.arn
    type             = "forward"
  }
}


# ECS Service for Poll 
resource "aws_ecs_service" "onchain-poll-service" {
  name                      = "${terraform.workspace}-poll-service"
  cluster                   = aws_ecs_cluster.onchain.id
  task_definition           = aws_ecs_task_definition.onchain_poll_service.arn
  desired_count             = 1
  #iam_role                  = aws_iam_role.ecs-service-role.arn

  # network_configuration {
  #   subnets          = var.private_subnets
  #   security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
  #   assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  # }

  load_balancer {
    target_group_arn         = aws_lb_target_group.nlb-poll-target-group.arn
    container_name           = "${terraform.workspace}-poll"
    container_port           = 4002
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

##################################################

#ELB Target Group for Reward Service
resource "aws_lb_target_group" "nlb-reward-target-group" {
  name        = "${terraform.workspace}-reward-target-group"  
  port        = 4004
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  #target_type = var.nlb_target_type

  health_check {
    path                = "/reward-api/v1/health-check"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "reward-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 4004
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-reward-target-group.arn
    type             = "forward"
  }
}


# ECS Service for Reward Service
resource "aws_ecs_service" "onchain-reward-service" {
  name                      = "${terraform.workspace}-reward-service"
  cluster                   = aws_ecs_cluster.onchain.id
  task_definition           = aws_ecs_task_definition.onchain_reward_service.arn
  desired_count             = 1
  #iam_role                  = aws_iam_role.ecs-service-role.arn

  # network_configuration {
  #   subnets          = var.private_subnets
  #   security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
  #   assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  # }

  load_balancer {
    target_group_arn         = aws_lb_target_group.nlb-reward-target-group.arn
    container_name           = "${terraform.workspace}-reward"
    container_port           = 4004
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

##################################################

#ELB Target Group for BlockChain Service
resource "aws_lb_target_group" "nlb-blockchain-target-group" {
  name        = "${terraform.workspace}-blockchain-tg"  
  port        = 4003
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  #target_type = var.nlb_target_type

  health_check {
    path                = "/blockchain-api/v1/health-check"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "blockchain-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 4003
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-blockchain-target-group.arn
    type             = "forward"
  }
}

# ECS Service
resource "aws_ecs_service" "onchain-blockchain-service" {
  name                      = "${terraform.workspace}-blockchain-service"
  cluster                   = aws_ecs_cluster.onchain.id
  task_definition           = aws_ecs_task_definition.onchain_blockchain_service.arn
  desired_count             = 1
  #iam_role                  = aws_iam_role.ecs-service-role.arn

  # network_configuration {
  #   subnets          = var.private_subnets
  #   security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
  #   assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  # }

  load_balancer {
    target_group_arn         = aws_lb_target_group.nlb-blockchain-target-group.arn
    container_name           = "${terraform.workspace}-blockchain"
    container_port           = 4003
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

##################################################

resource "aws_api_gateway_vpc_link" "vpc_link" {
 name        = "${terraform.workspace}-vpc-link"
 target_arns = [ aws_lb.nlb.arn ]
}

resource "aws_api_gateway_rest_api" "uat-apigatway" {
  name        = "${terraform.workspace}-api-gateway"
  description = "UAT API Gateway"
   endpoint_configuration {
    types = ["REGIONAL"]
  }
}
