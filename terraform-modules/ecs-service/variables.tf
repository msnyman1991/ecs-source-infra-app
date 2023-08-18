variable "create" {
  default = true
}

variable "create_task_definition" {
  default = true
}

variable "ecs_container_port" {
  type = any
}

variable "ecs_host_port" {
  type = number
}

variable "ecs_container_cpu" {
  type = string
}

variable "ecs_container_memory" {
  type = string
}

variable "image" {
  type = string
}

variable "image_version" {
  type = string
}

variable "app_name" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_account_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "env_variables" {
  type    = list(map(string))
  default = []
}

variable "secret_env_variables" {
  type    = list(map(string))
  default = []
}