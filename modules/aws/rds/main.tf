locals {
  create_subnet_group = var.create_db_subnet_group
  subnet_group_name   = local.create_subnet_group ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name
}

resource "aws_db_subnet_group" "this" {
  count = var.create_db_subnet_group ? 1 : 0

  name        = "${var.identifier}-subnet-group"
  description = "Database subnet group for ${var.identifier}"
  subnet_ids  = var.subnet_ids

  tags = merge(
    {
      Name = "${var.identifier}-subnet-group"
    },
    var.tags
  )
}

resource "aws_security_group" "this" {
  count = var.create_security_group ? 1 : 0

  name_prefix = "${var.identifier}-sg-"
  vpc_id      = var.vpc_id
  description = "Security group for ${var.identifier} database"

  tags = merge(
    {
      Name = "${var.identifier}-sg"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress" {
  count = var.create_security_group ? length(var.allowed_security_groups) : 0

  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_groups[count.index]
  security_group_id        = aws_security_group.this[0].id
  description              = "Allow access from application security groups"
}

resource "aws_security_group_rule" "ingress_cidr" {
  count = var.create_security_group && length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.this[0].id
  description       = "Allow access from CIDR blocks"
}

resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  username = var.username
  password = var.password
  port     = var.port

  vpc_security_group_ids = var.create_security_group ? [aws_security_group.this[0].id] : var.vpc_security_group_ids
  db_subnet_group_name   = local.subnet_group_name
  multi_az               = var.multi_az
  publicly_accessible    = false

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.identifier}-final-snapshot"

  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_enabled ? var.kms_key_id : null

  monitoring_interval = var.monitoring_interval
  # monitoring_role_arn = var.monitoring_role_arn # Optional: Add monitoring role support

  tags = merge(
    {
      Name = var.identifier
    },
    var.tags
  )
}
