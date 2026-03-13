module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "21.15.1"
  name               = var.name
  kubernetes_version = "1.33"

  enable_cluster_creator_admin_permissions = true
  endpoint_public_access                   = true
  control_plane_scaling_config = {
    tier = "standard"
  }

  create_kms_key = false # if you wana use existing KMS key

  encryption_config = {
    provider_key_arn = var.kms_key_id # if you wana use existing KMS key
    resources        = ["secrets"]
  }

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }


  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets


  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["c7i-flex.large"]

      min_size     = 1
      max_size     = 1
      desired_size = 1

      labels = {
        "karpenter.sh/controller" = "true"
      }

      # also you can specify taint to avoid scheduling unnecessary pods on karpenter nodes
    }
  }


  node_security_group_tags = merge(var.tags, {
    "karpenter.sh/discovery" = var.name
  })
  tags = var.tags
}


resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = module.eks.cluster_name
  addon_name   = "aws-ebs-csi-driver"
  pod_identity_association {
    role_arn        = aws_iam_role.ebs_csi_driver.arn
    service_account = "ebs-csi-controller-sa"
  }
}



resource "aws_iam_role" "ebs_csi_driver" {
  name = "${var.name}-ebs-csi"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

}


resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
