module "vpc" {
  source = "./Modules/vpc"
}

module "rds" {
  source          = "./Modules/RDS"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  count           = 0
}



module "opensearch" {
  source = "./Modules/OpenSearch"
  count  = 0
  vpc_id = module.vpc.vpc_id
  # public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  depends_on      = [module.vpc]

}

module "ECS" {
   source = "./Modules/ecs"
   count  = 1
   vpc_id          = module.vpc.vpc_id
   private_subnets = module.vpc.private_subnets
   depends_on      = [module.vpc]

 }

module "frontend" {
  source = "./Modules/frontend"
  count  = 1
}
# terraform {
# backend "s3" {
# bucket = "XXXXXXXX"
# key = "terraform.tfstate"
# region = "eu-west-2"
# encrypt = true
# }
# }


