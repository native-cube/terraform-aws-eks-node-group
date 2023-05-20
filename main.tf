resource "aws_eks_node_group" "main" {
  count = var.create_before_destroy ? 0 : 1

  cluster_name = var.cluster_name

  node_group_name_prefix = var.node_group_name_prefix
  node_group_name        = var.node_group_name
  node_role_arn          = var.node_role_arn == null ? aws_iam_role.main[0].arn : var.node_role_arn

  subnet_ids = var.subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = var.instance_types
  capacity_type  = var.capacity_type

  labels = var.labels

  release_version = var.ami_release_version
  version         = var.kubernetes_version

  force_update_version = var.force_update_version

  tags = var.tags

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  dynamic "taint" {
    for_each = var.taints
    content {
      key    = lookup(taint.value, "key")
      value  = lookup(taint.value, "value")
      effect = lookup(taint.value, "effect")
    }
  }

  dynamic "remote_access" {
    for_each = var.ec2_ssh_key != null || var.source_security_group_ids != null ? ["true"] : []
    content {
      ec2_ssh_key               = var.ec2_ssh_key
      source_security_group_ids = var.source_security_group_ids
    }
  }

  dynamic "update_config" {
    for_each = length(var.update_config) == 0 ? [] : [var.update_config]
    content {
      max_unavailable            = lookup(update_config.value, "max_unavailable", null)
      max_unavailable_percentage = lookup(update_config.value, "max_unavailable_percentage", null)
    }
  }

  dynamic "launch_template" {
    for_each = length(var.launch_template) == 0 ? [] : [var.launch_template]
    content {
      id      = lookup(launch_template.value, "id", null)
      name    = lookup(launch_template.value, "name", null)
      version = lookup(launch_template.value, "version")
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}

resource "aws_eks_node_group" "main_create_before_destroy" {
  count = var.create_before_destroy ? 1 : 0

  cluster_name = var.cluster_name

  node_group_name_prefix = var.node_group_name_prefix
  node_group_name        = var.node_group_name
  node_role_arn          = var.node_role_arn == null ? aws_iam_role.main[0].arn : var.node_role_arn

  subnet_ids = var.subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = var.instance_types
  capacity_type  = var.capacity_type

  labels = var.labels

  release_version = var.ami_release_version
  version         = var.kubernetes_version

  force_update_version = var.force_update_version

  tags = var.tags

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  dynamic "taint" {
    for_each = var.taints
    content {
      key    = lookup(taint.value, "key")
      value  = lookup(taint.value, "value")
      effect = lookup(taint.value, "effect")
    }
  }

  dynamic "remote_access" {
    for_each = var.ec2_ssh_key != null || var.source_security_group_ids != null ? ["true"] : []
    content {
      ec2_ssh_key               = var.ec2_ssh_key
      source_security_group_ids = var.source_security_group_ids
    }
  }

  dynamic "update_config" {
    for_each = length(var.update_config) == 0 ? [] : [var.update_config]
    content {
      max_unavailable            = lookup(update_config.value, "max_unavailable", null)
      max_unavailable_percentage = lookup(update_config.value, "max_unavailable_percentage", null)
    }
  }

  dynamic "launch_template" {
    for_each = length(var.launch_template) == 0 ? [] : [var.launch_template]
    content {
      id      = lookup(launch_template.value, "id", null)
      name    = lookup(launch_template.value, "name", null)
      version = lookup(launch_template.value, "version")
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}
