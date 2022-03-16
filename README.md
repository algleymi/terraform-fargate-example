# terraform-fargate-example
using terraform to spin up a fargate ECS cluster

## pre-requisites
- AWS cli
- terraform

## running it

```bash
# navigate to the environment
$ cd live

# initialize the thing
$ terraform init

# check what will be provisioned
$ terraform plan

# provision it!
$ terraform apply

# deploy it!
$ aws ecs update-service --cluster example-cluster --service example-service --task-definition $(terraform output -json | jq -r ".task_definition_arn.value")
```