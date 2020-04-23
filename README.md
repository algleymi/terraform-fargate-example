# terragrunt-fargate-example
using terraform to spin up a fargate ECS cluster

## pre-requisites
- AWS cli
- terragrunt
- terraform

## running it

```bash
# navigate to the dev environment
$ cd infra/dev

# check what will be provisioned
$ terragrunt plan-all

# provision it!
$ terragrunt apply-all
```