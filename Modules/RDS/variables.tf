variable "allocated_storage" {
  description = "The amount of storage to allocate to the RDS instance (in GB)"
  type        = number
  default = 50
}

variable "engine" {
  description = "The database engine to use for the RDS instance"
  type        = string
  default = "postgres"
}

variable "engine_version" {
  description = "The version of the database engine to use for the RDS instance"
  type        = string
  default = "14.7"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default = "db.t4g.xlarge"
}

variable "db_username" {
  description = "The username for the RDS database"
  type        = string
  default = "postgres"
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  default = "fmVO3tqw"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}
