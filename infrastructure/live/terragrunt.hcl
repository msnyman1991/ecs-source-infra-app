terraform {
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=60m"]
  }
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}
EOF
}

## !!
generate "config" {
  path      = "config_generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "user" {
  type        = string
  description = "Current user who's executing the plan"
}

variable "env" {
  type        = string
  description = "Environment"
}
EOF
}