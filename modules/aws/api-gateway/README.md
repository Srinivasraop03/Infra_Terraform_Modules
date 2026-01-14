# AWS API Gateway Module (REST)

## 🧐 What is this?
This module creates a **REST API Interface** that sits at the edge of your network.

## ❓ Why use this module?
In modern "Private Microservices" architectures, you do NOT want your Kubernetes cluster or Load Balancers directly exposed to the public internet.

This module implements the **VPC Link Pattern**:
1.  **Public Traffic** hits this API Gateway (managed by AWS).
2.  **Authentication** happens here (Cognito/Lambda Authorizers).
3.  **VPC Link** tunnels the request securely into your VPC.
4.  **Internal NLB** receives the traffic and passes it to your valid service.

This means your backend is effectively "air-gapped" from the public internet.

## ⚙️ Usage Configuration

### Step 1: Create the Internal Load Balancer (NLB)
```hcl
module "eks_nlb" {
  source = "../../modules/aws/load-balancer"

  name               = "eks-vpc-link-nlb"
  load_balancer_type = "network"        # MUST be Network for VPC Link
  internal           = true             # MUST be Internal
  
  # ... (Target Groups pointing to EKS Nodes)
}
```

### Step 2: Create the API Gateway attached to it
```hcl
module "api_gateway" {
  source = "../../modules/aws/api-gateway"

  name        = "corporate-api"
  description = "Primary external gateway"
  
  # The Magic Glue: Valid ARNs of your internal NLB
  nlb_arns = [module.eks_nlb.lb_arn]

  # Logging
  access_log_group_arn = module.logs.log_group_arn
}
```
