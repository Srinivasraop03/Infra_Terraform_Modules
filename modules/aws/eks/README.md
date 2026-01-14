# AWS EKS (Elastic Kubernetes Service) Module

## 🧐 What is this?
This module provisions a **Kubernetes Cluster**.

It sets up two main components:
1.  **Control Plane**: The "Brain" of Kubernetes (managed by AWS).
2.  **Node Groups**: The "Workers" (EC2 instances) where your actual code runs.

## ❓ Why use this module?
Setting up EKS by hand is notoriously difficult. This module simplifies it while adding critical security features:
1.  **OIDC Identity Provider**: This enables **IRSA (IAM Roles for Service Accounts)**. Instead of giving your Pods dangerous permanent Access Keys, they "assume" IAM roles temporarily. This is the gold standard for container security.
2.  **Private Endpoints**: The Control Plane API is hidden from the public internet. It is only accessible from within your VPC (or via VPN), preventing internet-based attacks.
3.  **Encrypted Secrets**: It uses the KMS key to encrypt Kubernetes Secrets (passwords/keys) *inside* the etcd database.

## ⚙️ Usage Configuration

```hcl
module "eks" {
  source = "../../modules/aws/eks"

  cluster_name    = "prod-app-cluster"
  cluster_version = "1.27"
  
  # Network placement
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  # Security
  kms_key_arn = module.kms.key_arn
  
  # Worker Nodes Configuration
  node_groups = {
    # 1. Main Application Nodes
    general_apps = {
      desired_size   = 3
      instance_types = ["t3.large"]
    }
    
    # 2. High CPU Nodes for processing
    data_processing = {
      desired_size   = 2
      instance_types = ["c5.xlarge"]
      labels         = { workload = "data" } # K8s label
    }
  }
}
```

## ⚠️ Important Note on Access
Because `cluster_endpoint_public_access` is set to `false` (default), you **cannot** run `kubectl` commands from your laptop unless you are connected to the VPC via VPN. This is standard enterprise security procedure.
