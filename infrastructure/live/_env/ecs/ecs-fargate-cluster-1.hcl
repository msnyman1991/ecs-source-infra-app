terraform {
  source = "../../../../terraform-modules//ecs-fargate-cluster"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
  ## ECS Cluster
  cluster_name                       = "account-management-b2b"
  cluster_cloud_watch_log_group_name = "/aws/ecs/ecs-fargate-events-processor"
  aws_account_id                     = get_aws_account_id()
  vpc_id                             = "vpc-123456789"
  ingress_cidr_blocks                = ["0.0.0.0/0"]
  subnet_ids                         = ["subnet-123456", "subnet-123456", "subnet-123456"]
  create_security_group              = true ## If set to false a new sg won't be created and the value for security_groups input will be used
  security_group_name                = "ecs-service-1-security-group"
}
