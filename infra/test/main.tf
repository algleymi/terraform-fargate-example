module "network" {
  source = "../modules/network"

  identifier = var.identifier
  region = var.region
}

module "lb" {
  source = "../modules/loadbalancer"

  identifier = var.identifier
  region = var.region
  vpc_id = module.network.vpc_id
  lb_subnets = module.network.private_subnet_ids
}
