locals {
  identifier = "example"
}

module "application" {
  source = "../modules/application"

  identifier = local.identifier
  image_tag = var.image_tag
}

module "network" {
  source = "../modules/network"

  identifier = local.identifier
}

module "load_balancer" {
  source = "../modules/loadbalancer"

  identifier = local.identifier

  lb_subnets = module.network.public_subnet_ids
  vpc_id     = module.network.vpc_id
}

module "fargate" {
  source = "../modules/fargate"

  identifier = local.identifier

  subnets                    = module.network.private_subnet_ids
  vpc_id                     = module.network.vpc_id
  load_balancer_listener_arn = module.load_balancer.load_balancer_listener_arn
}
