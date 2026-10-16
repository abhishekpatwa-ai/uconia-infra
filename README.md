# uconia-infra

The shared foundation of the Uconia platform on AWS, built with Terraform. It is created once and changes rarely. Every service runs on top of it.

| Folder | What it creates | Outputs other stacks read |
|---|---|---|
| `bootstrap/` | S3 bucket for all Terraform state (versioning, encryption, locking, prevent_destroy) | — |
| `network/` | VPC across 2 AZs, public/private subnets, IGW, NAT, security groups | `vpc_id`, `private_subnet_ids`, `app_sg_id`, … |
| `alb/` | Shared ALB and HTTP listener (default 404) | `listener_arn`, `alb_url` |
| `cluster/` | ECS cluster (Container Insights) and the ECR scan-on-push rule | `cluster_name` |
| `oidc/` | GitHub OIDC provider, so pipelines never need AWS access keys | `oidc_provider_arn` |

## How stacks talk to each other

Each folder writes its outputs to its state file in the S3 bucket. The next folder reads them with `terraform_remote_state`, for example `alb/data.tf` reads the network outputs. Services in [uconia-golden-path](https://github.com/abhishekpatwa-ai/uconia-golden-path) read all of them.

## State keys

The state files keep their original keys from the learning repo (`week2-network/…`, `week3-alb/…`, `week4-ecs/…`, `week5-cicd/…`), so moving the folders needed no state migration.

## Order

- Create: `bootstrap` (once) → `network` → `alb` → `cluster` → `oidc`
- Destroy: the reverse, after the services in uconia-golden-path are destroyed. `oidc` costs nothing and can stay.

## Related repos

- [uconia-golden-path](https://github.com/abhishekpatwa-ai/uconia-golden-path): the module and pipeline every service uses
- [uconia-api](https://github.com/abhishekpatwa-ai/uconia-api): the first service
