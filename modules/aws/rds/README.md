# AWS RDS (Relational Database Service) Module

## 🧐 What is this?
This module creates a fully managed **SQL Database** (PostgreSQL or MySQL). 

It handles the heavy lifting of:
- Launching the database server.
- Configuring the network (Subnet Groups).
- Setting up firewalls (Security Groups).
- Automating backups and maintenance.

## ❓ Why use this module?
1.  **Security by Default**:
    - **Encryption**: Forces you to provide a KMS key (from our `kms` module) so data is encrypted at rest.
    - **Private Networking**: It only places the DB in *Private Subnets*. It creates a "Subnet Group" automatically so the DB is never accessible from the public internet.
2.  **High Availability**: The `multi_az` option automatically creates a standby clone in a different Availability Zone. If the main data center fails, AWS creates a failover instantly.
3.  **Managed Backups**: Automated snapshots are configured out of the box.

## ⚙️ Usage Configuration

```hcl
module "rds" {
  source = "../../modules/aws/rds"

  # 1. Identity
  identifier = "prod-finance-db"
  username   = "admin"
  password   = var.db_password  # WARN: Pass this in via a secure variable!

  # 2. Capacity
  engine         = "postgres"
  engine_version = "14.7"
  instance_class = "db.t3.medium" # Vertical Scaling
  
  # 3. Security (Critical)
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids # Must be PRIVATE
  kms_key_id        = module.kms.key_arn            # Must use CMK
  storage_encrypted = true
  
  # 4. Access Control
  # Only allow traffic from the Application Server (EKS or EC2)
  allowed_security_groups = [module.eks_node_sg.id] 
}
```

## 📋 Inputs

| Input | Description | Recommendation |
|-------|-------------|----------------|
| `multi_az` | Deploy standby replica | `true` for Prod, `false` for Dev |
| `instance_class` | Size of the server | Start small (`db.t3.medium`) and scale up |
| `skip_final_snapshot` | Snapshot before delete? | `false` for Prod (Always save data!) |
