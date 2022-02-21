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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_release_version"></a> [ami\_release\_version](#input\_ami\_release\_version) | AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version | `string` | `null` | no |
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values: AL2\_x86\_64 \| AL2\_x86\_64\_GPU \| AL2\_ARM\_64 \| CUSTOM \| BOTTLEROCKET\_ARM\_64 \| BOTTLEROCKET\_x86\_64. Terraform will only perform drift detection if a configuration value is provided. | `string` | `null` | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | Type of capacity associated with the EKS Node Group. Defaults to ON\_DEMAND. Valid values: ON\_DEMAND, SPOT. | `string` | `"ON_DEMAND"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Create IAM role for node group. Set to false if pass `node_role_arn` as an argument | `bool` | `true` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desired number of worker nodes. | `number` | n/a | yes |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Disk size in GiB for worker nodes. Defaults to 20. Terraform will only perform drift detection if a configuration value is provided. | `number` | `null` | no |
| <a name="input_ec2_ssh_key"></a> [ec2\_ssh\_key](#input\_ec2\_ssh\_key) | EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group. If you specify this configuration, but do not specify source\_security\_group\_ids when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0). | `string` | `null` | no |
| <a name="input_enable_iam_role_ssm_policy"></a> [enable\_iam\_role\_ssm\_policy](#input\_enable\_iam\_role\_ssm\_policy) | Enable addition of managed policy called `AmazonSSMManagedInstanceCore` to enable SSM monitoring. | `bool` | `true` | no |
| <a name="input_force_update_version"></a> [force\_update\_version](#input\_force\_update\_version) | Force version update if existing pods are unable to be drained due to a pod disruption budget issue. | `bool` | `false` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | List of instance types associated with the EKS Node Group. Terraform will only perform drift detection if a configuration value is provided | `list(string)` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed | `map(string)` | `{}` | no |
| <a name="input_launch_template"></a> [launch\_template](#input\_launch\_template) | Configuration block with Launch Template settings. `name`, `id` and `version` parameters are available. | `map(string)` | `{}` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of worker nodes. | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of worker nodes. | `number` | n/a | yes |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | The name of the cluster node group. Defaults to <cluster\_name>-<random value> | `string` | `null` | no |
| <a name="input_node_group_name_prefix"></a> [node\_group\_name\_prefix](#input\_node\_group\_name\_prefix) | Creates a unique name beginning with the specified prefix. Conflicts with node\_group\_name | `string` | `null` | no |
| <a name="input_node_group_role_name"></a> [node\_group\_role\_name](#input\_node\_group\_role\_name) | The name of the cluster node group role. Defaults to <cluster\_name>-managed-group-node | `string` | `null` | no |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | IAM role arn that will be used by managed node group. | `string` | `null` | no |
| <a name="input_source_security_group_ids"></a> [source\_security\_group\_ids](#input\_source\_security\_group\_ids) | Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes. If you specify ec2\_ssh\_key, but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0) | `list(string)` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs to launch resources in. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags (key-value pairs) passed to resources. | `map(string)` | `{}` | no |
| <a name="input_taints"></a> [taints](#input\_taints) | List of objects containing Kubernetes taints which will be applied to the nodes in the node group. Maximum of 50 taints per node group. | `list(object({ key = string, value = any, effect = string }))` | `[]` | no |
| <a name="input_update_config"></a> [update\_config](#input\_update\_config) | Update config configuration block which is a key-value map. Accepted argmuents are `max_unavailable` and `max_unavailable_percentage`. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM role ARN used by node group. |
| <a name="output_iam_role_id"></a> [iam\_role\_id](#output\_iam\_role\_id) | IAM role ID used by node group. |
| <a name="output_node_group"></a> [node\_group](#output\_node\_group) | Outputs from EKS node group. See `aws_eks_node_group` Terraform documentation for values |
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
