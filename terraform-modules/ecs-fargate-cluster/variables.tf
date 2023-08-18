variable "family" {
  type = string
}

variable "ecs_service_name" {
  type    = string
  default = ""
}

variable "aws_account_id" {
}

variable "vpc_id" {
  default = ""
}

variable "cluster_name" {
  type = string
}

variable "cluster_cloud_watch_log_group_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "custom_actions" {
  type    = list(string)
  default = []
}

variable "security_group_name" {
  type    = string
  default = ""
}

variable "service_discovery_service_arn" {
  type    = string
  default = ""
}

variable "create_security_group" {
  default = false
}

variable "ingress_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "desired_count" {
  type    = string
  default = "1"
}

variable "container_definition" {
  type    = string
  default = ""
}

variable "ecs_service_discovery_namespace" {
  type    = string
  default = ""
}

variable "create_private_dns_output" {
  type    = bool
  default = true
}