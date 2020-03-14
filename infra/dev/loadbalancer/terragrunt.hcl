include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    vpc_id = "exposed-mock-vpc-id"
    network_acl_id = "exposed-mock-acl-id"
    private_subnet_ids = [
      "exposed-mock-private-subnet-a-id",
      "exposed-mock-private-subnet-b-id"
    ]
  }
}

terraform {
  source = "../../modules/loadbalancer"
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  lb_subnets = dependency.network.outputs.public_subnet_ids
}
