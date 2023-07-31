# cluster
resource "aws_ecs_cluster" "gomeme" {
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
    value               = "${terraform.workspace}-ecs-ec2-container"
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
############################################################3

#NLB Target Group for auth Service
resource "aws_lb_target_group" "nlb-auth-target-group" {
  name        = "${terraform.workspace}-auth-target-group"  
  port        = 5010
  protocol    = "TCP"
  vpc_id      = var.vpc_id
 # target_type = var.nlb_target_type

  health_check {
    path                = "/v1/healthcheck/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

#ELB auth Service Listener
resource "aws_lb_listener" "auth-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 5010
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-auth-target-group.arn
    type             = "forward"
  }
}


# ECS auth Service
resource "aws_ecs_service" "gomeme-auth-service" {
  name                      = "${terraform.workspace}-auth-service"
  cluster                   = aws_ecs_cluster.gomeme.id
  task_definition           = aws_ecs_task_definition.gomeme_auth_service.arn
  desired_count             = 1
  #iam_role                  = aws_iam_role.ecs-service-role.arn

  # network_configuration {
  #   subnets          = var.private_subnets
  #   security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
  #   assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  # }

  load_balancer {
    target_group_arn         = aws_lb_target_group.nlb-auth-target-group.arn
    container_name           = "${terraform.workspace}-auth"
    container_port           = 5010
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

##################################################

#ELB Target Group for Poll Service
resource "aws_lb_target_group" "nlb-notification-target-group" {
  name        = "${terraform.workspace}-notification-target-group"  
  port        = 5020
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  #target_type = var.nlb_target_type

  health_check {
    path                = "v1/healthcheck"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "nlb-notification-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 5020
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-notification-target-group.arn
    type             = "forward"
  }
}


# ECS Service for notification 
resource "aws_ecs_service" "gomeme-notification-service" {
  name                      = "${terraform.workspace}-notification-service"
  cluster                   = aws_ecs_cluster.gomeme.id
  task_definition           = aws_ecs_task_definition.gomeme_notification_service.arn
  desired_count             = 1
  #iam_role                  = aws_iam_role.ecs-service-role.arn

  # network_configuration {
  #   subnets          = var.private_subnets
  #   security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
  #   assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  # }

  load_balancer {
    target_group_arn         = aws_lb_target_group.nlb-notification-target-group.arn
    container_name           = "${terraform.workspace}-notification"
    container_port           = 5020
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

##################################################

#ELB Target Group for user Service
resource "aws_lb_target_group" "nlb-user-target-group" {
  name        = "${terraform.workspace}-user-tg"  
  port        = 5030
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  #target_type = var.nlb_target_type

  health_check {
    path                = "/v1/healthcheck"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "user-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 5030
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-user-target-group.arn
    type             = "forward"
  }
}

# ECS Service
resource "aws_ecs_service" "gomeme-user-service" {
  name                      = "${terraform.workspace}-user-service"
  cluster                   = aws_ecs_cluster.gomeme.id
  task_definition           = aws_ecs_task_definition.gomeme_user_service.arn
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
    container_port           = 5030
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

##################################################

#ELB Target Group for Reward Service
resource "aws_lb_target_group" "nlb-reward-target-group" {
  name        = "${terraform.workspace}-reward-target-group"  
  port        = 5040
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  #target_type = var.nlb_target_type

  health_check {
    path                = "/v1/healthcheck"
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
  port              = 5040
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-reward-target-group.arn
    type             = "forward"
  }
}


# ECS Service for Reward Service
resource "aws_ecs_service" "gomeme-reward-service" {
  name                      = "${terraform.workspace}-reward-service"
  cluster                   = aws_ecs_cluster.gomeme.id
  task_definition           = aws_ecs_task_definition.gomeme_reward_service.arn
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
    container_port           = 5040
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

##################################################

#ELB Target Group for cms Service
resource "aws_lb_target_group" "nlb-cms-target-group" {
  name        = "${terraform.workspace}-cms-tg"  
  port        = 5050
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  #target_type = var.nlb_target_type

  health_check {
    path                = "/v1/healthcheck"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "cms-nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 5050
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb-cms-target-group.arn
    type             = "forward"
  }
}

# ECS Service
resource "aws_ecs_service" "gomeme-cms-service" {
  name                      = "${terraform.workspace}-cms-service"
  cluster                   = aws_ecs_cluster.gomeme.id
  task_definition           = aws_ecs_task_definition.gomeme_cms_service.arn
  desired_count             = 1
  #iam_role                  = aws_iam_role.ecs-service-role.arn

  # network_configuration {
  #   subnets          = var.private_subnets
  #   security_groups  = [aws_security_group.ecs-launchconfig-sg.id]
  #   assign_public_ip = false  # Set this to true if you want to assign public IPs to the containers
  # }

  load_balancer {
    target_group_arn         = aws_lb_target_group.nlb-cms-target-group.arn
    container_name           = "${terraform.workspace}-cms"
    container_port           = 5030
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}