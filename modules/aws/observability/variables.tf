variable "name" {
  description = "Base name for resources (Log Group, SNS Topic prefix)"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "KMS Key ARN to encrypt the logs"
  type        = string
  default     = null
}

variable "alarms" {
  description = "Map of alarm configurations"
  type        = any
  default     = {}
}

variable "create_sns_topic" {
  description = "Whether to create a default SNS topic for alerts"
  type        = bool
  default     = true
}

variable "sns_topic_arns" {
  description = "List of existing SNS Topic ARNs to notify (if not using the default one)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
