module "eks" {

  # import the module template
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31" # Recommended to specify the module version

  # cluster info (control plane)
  cluster_name                   = local.name
  cluster_version                = "1.31"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  # cluster_addons is 
  cluster_addons = {
    vpc-cni = {
      most-recent = true
    }
    kube-proxy = {
      most-recent = true
    }
    core-dns = {
      most-recent = true
    }
  }

  # control plane network
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group Defaults (Shared configuration)
  # managing nodes in the cluster, including instance types, scaling configuration, and capacity type (on-demand or spot).
  eks_managed_node_group_defaults = {

    instance_types                = ["t2.medium"]
    attach_primary_security_group = true
  }

  # Specific Node Group Configuration
  eks_managed_node_groups = {
    tws-cluster-node-grp = {
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2

      capacity_type = "SPOT"
    }
  }



  tags = {
    Terraform   = "true"
    Environment = local.env
  }

}
