# AWS Load Balancer Module

## 🧐 What is this?
This module provisions a Load Balancer (LB) to distribute traffic across your servers. 

It supports two types:
1.  **ALB (Application Load Balancer)**: Best for standard websites. It understands HTTP/HTTPS, cookies, and paths (e.g., `/api` vs `/images`).
2.  **NLB (Network Load Balancer)**: Best for high performance or **Private Connectivity**. It only understands pure TCP traffic.

## ❓ When to use which?

| Feature | Choose **ALB** if... | Choose **NLB** if... |
|---------|----------------------|----------------------|
| **Use Case** | Traditional Websites, Microservices | API Gateway VPC Link, Ultra-low latency |
| **Protocol** | HTTP / HTTPS | TCP / UDP |
| **Speed** | Fast | Ultra Fast (Millions of requests/sec) |
| **Static IP?** | No | Yes (Optional) |

## ⚙️ Usage Examples

### Scenario A: Standard Internal Web Service (ALB)
```hcl
module "internal_alb" {
  source = "../../modules/aws/load-balancer"

  load_balancer_type = "application"
  internal           = true 
  security_groups    = [module.alb_sg.id]
  
  listeners = {
    "https" = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = "arn:aws:acm:..."
      action_type     = "forward"
      target_group_key = "app-target"
    }
  }
}
```

### Scenario B: EKS Integration for API Gateway (NLB)
```hcl
module "eks_nlb" {
  source = "../../modules/aws/load-balancer"

  load_balancer_type = "network"
  internal           = true
  
  # For EKS, we often use TCP passthrough
  listeners = {
    "tcp-80" = {
      port             = 80
      protocol         = "TCP"
      action_type      = "forward"
      target_group_key = "eks-nodes"
    }
  }
}
```
