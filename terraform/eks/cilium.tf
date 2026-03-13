# You have two options to install Cilium 
# 1. Install Cilium without default addons.
# 2. Install first vpc cni and disable cilium installation.
# We will use first option
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name               = "cillium-eks-cluster"
  kubernetes_version = "1.33"

  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }

  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  node_security_group_tags = {
    "karpenter.sh/discovery" = "cillium-eks-cluster"
  }
  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}
#We can create first helm releast and later node group it doesn't mattter
#Nodes will be in NotReady state until cilium is installed and running

resource "helm_release" "cilium" {
  name             = "cilium"
  namespace        = "cilium"
  create_namespace = true
  repository       = "oci://quay.io/cilium/charts/"
  chart            = "cilium"
  wait             = false

  values = [
    <<-YAML
    ingressController:
      enabled=true
      loadbalancerMode=dedicated
    envoyConfig:
      enabled=true
    loadBalancer:
      l7:
        backend=envoy
    eni:
      enabled: true
    hubble:

      relay:
        enabled: true
      ui:
        enabled: true
    ipam:
      mode: eni
    egressMasqueradeInterfaces: eth0
    k8sServiceHost: ${module.eks.cluster_endpoint}
    k8sServicePort: 443
    kubeProxyReplacement: true
    policyEnforcementMode: default
    routingMode: native
    YAML
  ]
  depends_on = []
}

resource "aws_eks_node_group" "main" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "main"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = module.vpc.private_subnets
  instance_types  = ["c7i-flex.large"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    helm_release.cilium,
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_iam_role" "worker" {
  name = "eks-node-group-worker"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}
resource "aws_iam_role_policy_attachment" "example-AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.worker.name
}
