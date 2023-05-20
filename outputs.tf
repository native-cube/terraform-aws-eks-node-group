output "iam_role_arn" {
  description = "IAM role ARN used by node group."
  value       = try(aws_iam_role.main[0].arn, null)
}

output "iam_role_id" {
  description = "IAM role ID used by node group."
  value       = try(aws_iam_role.main[0].id, null)
}

output "node_group" {
  description = "Outputs from EKS node group. See `aws_eks_node_group` Terraform documentation for values"
  value       = var.create_before_destroy ? try(aws_eks_node_group.main_create_before_destroy[0], null) : try(aws_eks_node_group.main[0], null)
}
