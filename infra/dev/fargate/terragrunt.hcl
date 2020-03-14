include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/fargate"
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    vpc_id = "exposed-mock-vpc-id",
    subnets = [
      "exposed-private-mock-subnet-id-1",
      "exposed-private-mock-subnet-id-2"
    ]
  }
}

dependency "loadbalancer" {
  config_path = "../loadbalancer"

  mock_outputs = {
    lb_id = "exposed-mock-lb-id"
    lb_http_listener_arn = "exposed-mock-lb-http-listener-arn"
  }
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id,
  lb_http_listener_arn = dependency.loadbalancer.outputs.lb_http_listener_arn,
  subnets = dependency.network.outputs.private_subnet_ids
}