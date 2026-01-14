# AWS KMS (Key Management Service) Module

## 🧐 What is this?
This module creates a **Customer Managed Key (CMK)** in AWS KMS. 

In simplified terms: AWS has default encryption keys, but for serious enterprise security, you want to "own" the key. This module creates a master key that *you* control, which is then used to encrypt other real services like your specific S3 buckets or RDS databases.

## ❓ Why use this module?
1.  **Compliance (SOC2/PCI)**: Compliance standards often require that you have control over the key rotation and deletion policies. The default AWS keys don't give you this control.
2.  **Key Rotation**: This module enables automatic key rotation (every year) by default. If a key is ever compromised, the rotation limits the blast radius.
3.  **Audit Trail**: Using a CMK allows you to see exactly *which* user or service used the key in CloudTrail logs.

## ⚙️ Usage Configuration

```hcl
module "kms" {
  source = "../../modules/aws/kms"

  # The 'alias' is the friendly name you will see in the console.
  alias       = "my-project-key"
  description = "Master key for encrypting Production Data"

  # Enterprise Security Best Practices
  enable_key_rotation     = true  # Default: true
  deletion_window_in_days = 30    # Safety buffer before permanent deletion
}
```

## 📋 Inputs

| Name | Description | Default |
|------|-------------|---------|
| `alias` | **(Required)** The friendly display name (e.g. `my-app-db`). | N/A |
| `description` | Context for what this key protects. | `KMS key...` |
| `enable_key_rotation` | Automatically rotate cryptographic material annually. | `true` |
