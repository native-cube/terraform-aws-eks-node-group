variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes."
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes."
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes."
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch resources in."
  type        = list(string)
}

variable "node_role_arn" {
  type        = string
  description = "IAM role arn that will be used by managed node group."
  default     = null
}

variable "ami_type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values: AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 | BOTTLEROCKET_x86_64. Terraform will only perform drift detection if a configuration value is provided."
  default     = null
}

variable "disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes. Defaults to 20. Terraform will only perform drift detection if a configuration value is provided."
  default     = null
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types associated with the EKS Node Group. Terraform will only perform drift detection if a configuration value is provided"
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  default     = {}
}

variable "ec2_ssh_key" {
  type        = string
  description = "EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group. If you specify this configuration, but do not specify source_security_group_ids when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)."
  default     = null
}

variable "source_security_group_ids" {
  type        = list(string)
  default     = null
  description = "Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes. If you specify ec2_ssh_key, but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)"
}

variable "update_config" {
  type        = map(any)
  description = "Update config configuration block which is a key-value map. Accepted argmuents are `max_unavailable` and `max_unavailable_percentage`."
  default     = {}
}

variable "ami_release_version" {
  type        = string
  description = "AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided"
  default     = null
}

variable "create_iam_role" {
  type        = bool
  description = "Create IAM role for node group. Set to false if pass `node_role_arn` as an argument"
  default     = true
}

variable "enable_iam_role_ssm_policy" {
  type        = bool
  description = "Enable addition of managed policy called `AmazonSSMManagedInstanceCore` to enable SSM monitoring."
  default     = true
}

variable "node_group_name" {
  type        = string
  description = "The name of the cluster node group. Defaults to <cluster_name>-<random value>"
  default     = null
}

variable "node_group_name_prefix" {
  type        = string
  description = "Creates a unique name beginning with the specified prefix. Conflicts with node_group_name"
  default     = null
}

variable "node_group_role_name" {
  type        = string
  description = "The name of the cluster node group role. Defaults to <cluster_name>-managed-group-node"
  default     = null
}

variable "force_update_version" {
  type        = bool
  description = "Force version update if existing pods are unable to be drained due to a pod disruption budget issue."
  default     = false
}

variable "launch_template" {
  type        = map(string)
  description = "Configuration block with Launch Template settings. `name`, `id` and `version` parameters are available."
  default     = {}
}

variable "capacity_type" {
  type        = string
  description = "Type of capacity associated with the EKS Node Group. Defaults to ON_DEMAND. Valid values: ON_DEMAND, SPOT."
  default     = "ON_DEMAND"
}

variable "taints" {
  type        = list(object({ key = string, value = any, effect = string }))
  description = "List of objects containing Kubernetes taints which will be applied to the nodes in the node group. Maximum of 50 taints per node group."
  default     = []
}

variable "create_before_destroy" {
  type        = bool
  description = "Create new node group before destroying an old one. To be used with node_group_name_prefix argument."
  default     = false
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the node group"
  type        = map(string)
  default     = {}
}
