resource "aws_lb" "this" {
  name                             = var.name
  internal                         = var.internal
  load_balancer_type               = var.load_balancer_type
  security_groups                  = var.load_balancer_type == "application" ? var.security_groups : null
  subnets                          = var.subnets
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  access_logs {
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
    enabled = var.access_logs_enabled
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = each.key
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = try(each.value.target_type, "instance")

  health_check {
    enabled             = try(each.value.health_check.enabled, true)
    interval            = try(each.value.health_check.interval, 30)
    path                = try(each.value.health_check.path, null)
    port                = try(each.value.health_check.port, "traffic-port")
    protocol            = try(each.value.health_check.protocol, null)
    timeout             = try(each.value.health_check.timeout, 5)
    healthy_threshold   = try(each.value.health_check.healthy_threshold, 3)
    unhealthy_threshold = try(each.value.health_check.unhealthy_threshold, 3)
  }

  tags = var.tags
}

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = try(each.value.ssl_policy, null)
  certificate_arn   = try(each.value.certificate_arn, null)

  default_action {
    type             = each.value.action_type
    target_group_arn = each.value.action_type == "forward" ? aws_lb_target_group.this[each.value.target_group_key].arn : null
  }
}
