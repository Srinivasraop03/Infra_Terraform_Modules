# AWS Observability Module

## 🧐 What is this?
This module standardizes how **Monitoring** and **Logging** are set up.

It creates:
1.  **CloudWatch Log Groups**: Central destinations for your application and infrastructure logs.
2.  **CloudWatch Alarms**: Rules that trigger alerts when things break (e.g., "CPU > 80%").
3.  **SNS Topic**: A "notification channel" to send those alerts to email, Slack, or PagerDuty.

## ❓ Why use this module?
Without this module, logs are often scattered, unencrypted, or kept forever (costing huge amounts of money).
- **Cost Control**: Enforces a `retention_in_days` (e.g., 30 days) so you don't pay to store logs from 5 years ago.
- **Security**: Supports KMS encryption for sensitive logs.
- **Standardization**: Allows you to define alerts in Terraform variable maps rather than clicking in the console.

## ⚙️ Usage Examples

### 1. Simple Log Group (for API Gateway)
```hcl
module "api_logs" {
  source = "../../modules/aws/observability"

  name              = "/aws/api-gateway/corporate-api"
  retention_in_days = 30
  kms_key_id        = module.kms.key_arn
}
```

### 2. Monitoring Critical Infrastructure (CPU Alarm)
```hcl
module "ec2_alarms" {
  source = "../../modules/aws/observability"

  name             = "ec2-monitoring"
  create_sns_topic = true # Creates 'ec2-monitoring-alerts' topic

  alarms = {
    "high-cpu" = {
      metric_name        = "CPUUtilization"
      namespace          = "AWS/EC2"
      statistic          = "Average"
      period             = 300 # 5 minutes
      evaluation_periods = 2
      threshold          = 80
      comparison_operator = "GreaterThanThreshold"
      dimensions         = { InstanceId = "i-1234567890abcdef0" }
    }
  }
}
```
