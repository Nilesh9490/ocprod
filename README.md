# Prerequisites
Before using this Terraform code, ensure that you have the following prerequisites installed on your local machine:

- Terraform (version 1.5.0 or later)
- Git

# terraform-aws-infra
terraform script for aws infrastructure

# GETTING STARTED 

# 1. Create Terraform Workspace 
* use terraform workspace to define name for specific resource / all the resouce will take worspace-name as prefix using following command

`terraform workspace new project-test`

* remember to create workspace only using lower case alphabets and hyphen 

# 2. Customize main.tf

* change count from 0 to desired number in each resource block for creating your desired infrastructure 

# 3. Add Your AWS Access Key-pair and Desired Region

* generate a set of unique access key-pair using AWS 
* Add access key and your desired region-code to variable.tf file 

# 4. Run Following Terraform Commands

`terraform init`
`terraform plan`
`terraform apply`ONCHAIN

# 5. Resources Managed By Terraform for production environment -

* VPC
Cidr 
3 private subnets
3 public subnets
3 availability zone
1 nat gateway
 
* Elastic container service 
    ECS cluster 
        EC2 launch_config
        Auto_scaling 
    ECS services
    Task definitions
    Network Load Balancer
        Subnet mappings
        Target groups 
        Listeners 
    IAM Role
        Policy
        Attachment with service/instance
    Security Groups
        Inbound / Outbound
    ECR 
    Api-gateway
        Resources/methods/deployment
    VPC link

* Frontend 
    S3
        Cloudfront + distribution 

* Open Search
    Domain

* RDS

* Instance (Jumphost)

# 6. Resources To Be Managed Manually for production environment -

* Bitbucket Pipelines 

    The Bitbucket provider is currently unavailable on the Terraform official registry. This unavailability has implications on our ability to utilize Terraform for managing Bitbucket resources, that is, create pipelines for automation, using terraform. Hence this should be managed manually via the Bitbucket web interface.

* Image for Elastic Container Registry

    The docker images need to be pushed to ECR which indirectly depends on pipelines and hence this needs to be done manually.

* CloudFront Integration for Backend Services

    Integrating backend services require Api Gateway and NLB integration which needs to be setup using AWS console once the respective resources are deployed using terraform 

* Frontend Services Deployment on S3 Bucket

    This Deployment also depends on bitbucket pipelines and hence the frontend services files can not be deployed on s3 using terraform  













