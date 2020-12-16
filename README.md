# terraform-fargate-example
using terraform to spin up a fargate ECS cluster

## pre-requisites
- AWS cli
- terraform

## running it

```bash
# navigate to the dev environment
$ cd infra/dev

# check what will be provisioned
$ terraform plan

# provision it!
$ terraform apply

# deploy it!
$ aws ecs update-service --cluster exposed-cluster --service exposed-service --task-definition $(terraform output -json | jq -r ".task_definition_arn.value")
```