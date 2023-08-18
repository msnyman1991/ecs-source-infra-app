terraform {
  extra_arguments "env" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
    ]

    arguments = [
      "-var", "user=${get_env("USER", "NOT_SET")}",
      "-var", "env=${get_env("TF_VAR_env", "dev")}",
      "-var", "app_name=${get_env("app_name", "")}",
    ]
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend_generated.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = ""

    key            = "${get_path_from_repo_root()}/${get_env("app_name", "")}/terraform.tfstate" 
    region         = "eu-west-1"                                                                 
    encrypt        = true
    dynamodb_table = ""
  }
}

generate "provider" {
  path      = "provider_generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      AwsEnvironment = title(var.env)
      Creator = "${get_env("USER", "NOT_SET")}"
      ManagedBy = "terraform"
    }
  }
}
EOF
}

locals {
  env    = "dev"
  region = "eu-west-1"
  azs = [
    "eu-west-1a",
    "eu-west-1b",
  "eu-west-1c"]
}