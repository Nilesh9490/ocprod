variable "vpc_id" {
  description = "VPC ID"
}
variable "private_subnets" {
  description = "private subnet IDs"
  #type        = list(string)
}
variable "ecs_instance_type" {
  description = "EC2 instance type for ECS instances"
  default     = "t3a.xlarge"
}
variable "ecs_ami_id" {
  description = "EC2 AMI ID for ECS instances"
  default     = "ami-0a9d0b31a17ab6ef5"
 }

variable "nlb_target_type" {
  default = "ip"
}


variable "task_network_mode" {
  default = "awsvpc"
}

variable "repo_names" {
  type    = list(string)
  default = ["user", "poll", "reward", "blockchain"]
}

variable "user_image"{
  default = "577900654051.dkr.ecr.eu-west-2.amazonaws.com/uat-onchain-user:latest"
}
variable "poll_image"{
  default = "577900654051.dkr.ecr.eu-west-2.amazonaws.com/uat-onchain-poll:latest"
}
variable "reward_image"{
  default = "577900654051.dkr.ecr.eu-west-2.amazonaws.com/uat-onchain-reward:latest"  
}
variable "blockchain_image"{
  default = "577900654051.dkr.ecr.eu-west-2.amazonaws.com/uat-onchain-blockchain:latest" 
}