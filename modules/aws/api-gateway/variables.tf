variable "name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "description" {
  description = "Description of the API Gateway"
  type        = string
  default     = null
}

variable "endpoint_types" {
  description = "List of endpoint types. Options: EDGE, REGIONAL, PRIVATE"
  type        = list(string)
  default     = ["REGIONAL"]
}

variable "nlb_arns" {
  description = "List of NLB ARNs for the VPC Link. Required for private EKS access."
  type        = list(string)
  default     = []
}

variable "stage_name" {
  description = "Name of the stage to deploy"
  type        = string
  default     = "v1"
}

variable "create_deployment" {
  description = "Whether to create a deployment"
  type        = bool
  default     = true
}

variable "redeployment_triggers" {
  description = "Map of values that trigger a redeployment"
  type        = map(string)
  default     = {}
}

variable "xray_tracing_enabled" {
  description = "Whether to enable X-Ray tracing"
  type        = bool
  default     = true
}

variable "logging_level" {
  description = "Logging level for Method Settings (OFF, ERROR, INFO)"
  type        = string
  default     = "INFO"
}

variable "access_log_group_arn" {
  description = "CloudWatch Log Group ARN for access logs"
  type        = string
}

variable "access_log_format" {
  description = "Format of the access logs"
  type        = string
  default     = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"caller\":\"$context.identity.caller\",\"user\":\"$context.identity.user\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
