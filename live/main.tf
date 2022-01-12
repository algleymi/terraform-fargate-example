module "network" {
  source = "../modules/network"
}

module "load_balancer" {
  source     = "../modules/loadbalancer"
  lb_subnets = module.network.public_subnet_ids
  vpc_id     = module.network.vpc_id
}

module "fargate" {
  source           = "../modules/fargate"
  subnets          = module.network.private_subnet_ids
  vpc_id           = module.network.vpc_id
  target_group_arn = module.load_balancer.target_group_arn
}