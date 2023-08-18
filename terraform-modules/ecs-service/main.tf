module "ecs_service" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs.git//modules/service"
  create      = var.create
  cluster_arn = "arn:aws:ecs:${var.region}:${var.aws_account_id}:cluster/${var.cluster_name}"
  create_task_definition    = var.create_task_definition
  network_mode              = "awsvpc"
  family                    = "${var.app_name}-family"
  name                      = var.app_name
  subnet_ids                = [""]
  security_group_ids        = [module.security_group.security_group_id]
  create_security_group = false
  deployment_controller = {
    minimum_healthy_percent = 100
    maximum_percent         = 200
    type                    = "ECS"
  }
  load_balancer = {
    service = {
      container_name   = var.app_name
      container_port   = var.ecs_container_port
      target_group_arn = element(module.alb.target_group_arns, 0)
    }
  }
  container_definitions = {
    task_definition = {
      readonly_root_filesystem = false
      name                     = var.app_name
      image                    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/${var.image}:${var.image_version}"
      port_mappings = [
        {
          containerPort = var.ecs_container_port
          protocol      = "tcp"
          hostPort      = var.ecs_host_port
        }
      ]
      environment = var.env_variables != null ? var.env_variables : []
      secrets     = var.secret_env_variables != null ? var.secret_env_variables : []
      cpu         = var.ecs_container_cpu
      memory      = var.ecs_container_memory
    }
  }
}

module "security_group" {
  source              = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//"
  name                = "${var.app_name}-sg"
  description         = "Service security group"
  vpc_id              = [""]
  ingress_rules       = ["http-${var.ecs_container_port}-tcp"]
  ingress_cidr_blocks = var.ingress_cidr_blocks

  egress_rules       = ["all-all"]
  egress_cidr_blocks = var.egress_cidr_blocks
}

module "alb" {
  source                = "git::https://github.com/terraform-aws-modules/terraform-aws-alb.git//"
  name                  = "${var.app_name}-alb"
  create_security_group = false
  load_balancer_type    = "application"

  vpc_id  = ""
  subnets = [""]

  security_groups = [module.security_group.security_group_id]

  http_tcp_listeners = [
    {
      port               = var.ecs_container_port
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "${var.app_name}-alb-tg"
      backend_protocol = "HTTP"
      backend_port     = var.ecs_container_port
      target_type      = "ip"
    },
  ]
}