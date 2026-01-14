variable "name" {
  description = "Name of the load balancer"
  type        = string
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = true
}

variable "load_balancer_type" {
  description = "Type of load balancer to create (application or network)"
  type        = string
  default     = "network"
  validation {
    condition     = contains(["application", "network"], var.load_balancer_type)
    error_message = "Valid values are 'application' or 'network'."
  }
}

variable "security_groups" {
  description = "List of security group IDs (application LB only)"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "List of subnet IDs to attach to the LB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for target groups"
  type        = string
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled (network LB only)"
  type        = bool
  default     = true
}

variable "access_logs_enabled" {
  description = "Enable access logs"
  type        = bool
  default     = false
}

variable "access_logs_bucket" {
  description = "S3 bucket name for access logs"
  type        = string
  default     = ""
}

variable "access_logs_prefix" {
  description = "S3 bucket prefix for access logs"
  type        = string
  default     = ""
}

variable "target_groups" {
  description = "Map of target group configurations"
  type        = any
  default     = {}
}

variable "listeners" {
  description = "Map of listener configurations"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
