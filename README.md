[![GitHub release (latest by date)](https://img.shields.io/github/v/release/native-cube/terraform-aws-eks-node-group)](https://github.com/native-cube/terraform-aws-eks-node-group/releases/latest)

# terraform-aws-eks-node-group
Terraform module to provision EKS Managed Node Group

## Usage

```hcl
module "eks-node-group" {
  source = "native-cube/eks-node-group/aws"
  version = "~> 1.0.0"

  cluster_name = aws_eks_cluster.cluster.id

  node_group_name_prefix = "eks-cluster-"

  subnet_ids = ["subnet-1","subnet-2","subnet-3"]

  desired_size = 1
  min_size     = 1
  max_size     = 1

  instance_types = ["t3.large","t2.large"]
  capacity_type  = "SPOT"

  ec2_ssh_key = "eks-test"

  labels = {
    lifecycle = "Spot"
  }

  taints = [
    {
      key    = "test-1"
      value  = null
      effect = "NO_SCHEDULE"
    },
    {
      key    = "test-2"
      value  = "value-test"
      effect = "NO_EXECUTE"
    }
  ]

  force_update_version = true

  tags = {
    Environment = "test"
  }
}
```

## Examples

* [EKS Single Node Group](https://github.com/native-cube/terraform-aws-eks-node-group/tree/main/examples/single-node-group)
* [EKS Single Node Group with Launch Template](https://github.com/native-cube/terraform-aws-eks-node-group/tree/main/examples/single-node-group-with-launch-template)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

See LICENSE for full details.

## Pre-commit hooks

### Install dependencies

* [`pre-commit`](https://pre-commit.com/#install)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs) required for `terraform_docs` hooks.
* [`TFLint`](https://github.com/terraform-linters/tflint) required for `terraform_tflint` hook.

#### MacOS

```bash
brew install pre-commit terraform-docs tflint

brew tap git-chglog/git-chglog
brew install git-chglog
```
