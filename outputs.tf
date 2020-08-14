output "lb_listener_rule_arn" {
  description = "AWS LB Listener Rule ARN"
  value       = try(aws_lb_listener_rule.this[0].arn, "")
}

output "user_pool_arn" {
  description = "Cognito User Pool ARN (will return the user provided ARN if `create_cognito_pool = false`)"
  value       = local.user_pool_arn
}

output "user_pool_client_id" {
  description = "Cognito User Pool ARN (will return the user provided ARN if `create_cognito_pool = false`)"
  value       = local.user_pool_client_id
}

output "user_pool_domain" {
  description = "Cognito User Pool ARN (will return the user provided ARN if `create_cognito_pool = false`)"
  value       = local.user_pool_domain
}
