output "api_id" {
  description = "The ID of the REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_arn" {
  description = "The ARN of the REST API"
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "vpc_link_id" {
  description = "The ID of the VPC Link"
  value       = aws_api_gateway_vpc_link.this.id
}

output "invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = aws_api_gateway_stage.this.invoke_url
}
