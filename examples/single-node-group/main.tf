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


resource "aws_security_group" "one" {
  name_prefix = "test-sg-one"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#####
# EKS Node Group
#####
module "eks-node-group" {
  source = "../../"

  cluster_name = aws_eks_cluster.cluster.id

  subnet_ids = data.aws_subnets.all.ids

  desired_size = 2
  min_size     = 1
  max_size     = 2

  capacity_type  = "SPOT"
  instance_types = ["t3.medium", "t2.medium"]

  ami_release_version  = "1.21.5-20220210"
  force_update_version = true

  ec2_ssh_key               = "eks-test"
  source_security_group_ids = [aws_security_group.one.id]

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
    },
    {
      key    = "test-3"
      value  = "value-test-3"
      effect = "PREFER_NO_SCHEDULE"
    }
  ]

  labels = {
    lifecycle = "SPOT"
  }

  update_config = {
    max_unavailable_percentage = 50
  }

  tags = {
    Environment = "test"
  }
}
