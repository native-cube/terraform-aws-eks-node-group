provider "aws" {
  region = "eu-west-1"
}

#####
# VPC and subnets
#####
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#####
# EKS Cluster
#####
resource "aws_eks_cluster" "cluster" {
  enabled_cluster_log_types = []
  name                      = "eks-node-group-module-cluster"
  role_arn                  = aws_iam_role.cluster.arn
  version                   = "1.21"

  vpc_config {
    subnet_ids              = data.aws_subnets.all.ids
    security_group_ids      = []
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  tags = {
    Environment = "test"
    Team        = ""
    Service     = "eks"
    Repository  = ""
  }
}

resource "aws_iam_role" "cluster" {
  name = "eks-node-group-module-cluster-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "eks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}

#####
# Launch Template with AMI
#####
data "aws_ssm_parameter" "cluster" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.cluster.version}/amazon-linux-2/recommended/image_id"
}

data "aws_launch_template" "cluster" {
  name = aws_launch_template.cluster.name

  depends_on = [aws_launch_template.cluster]
}

resource "aws_launch_template" "cluster" {
  image_id               = data.aws_ssm_parameter.cluster.value
  name                   = "eks-node-group-launch-template"
  update_default_version = true

  key_name = "eks-test"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 80
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                                  = "eks-node-group-instance-name"
      "kubernetes.io/cluster/eks-node-group-module-cluster" = "owned"
      Environment                                           = "test"
      Team                                                  = ""
      Service                                               = "eks"
      Repository                                            = ""
    }
  }

  user_data = base64encode(templatefile("userdata.tpl", { CLUSTER_NAME = aws_eks_cluster.cluster.name, B64_CLUSTER_CA = aws_eks_cluster.cluster.certificate_authority[0].data, API_SERVER_URL = aws_eks_cluster.cluster.endpoint, CONTAINER_RUNTIME = "containerd" }))
}

#####
# EKS Node Group
#####
module "eks-node-group" {
  source = "../../"

  node_group_name_prefix = "eks-node-group-"

  cluster_name = aws_eks_cluster.cluster.id

  instance_types = ["m5.large", "m5d.large", "m5a.large", "m5n.large"]

  subnet_ids = data.aws_subnets.all.ids

  desired_size = 1
  min_size     = 1
  max_size     = 3

  launch_template = {
    name    = data.aws_launch_template.cluster.name
    version = data.aws_launch_template.cluster.latest_version
  }

  capacity_type = "SPOT"

  labels = {
    lifecycle = "Spot"
  }

  tags = {
    "kubernetes.io/cluster/eks-node-group-module-cluster" = "owned"
    Environment                                           = "test"
    Team                                                  = ""
    Service                                               = "eks"
    Repository                                            = ""
  }

  depends_on = [data.aws_launch_template.cluster]
}
