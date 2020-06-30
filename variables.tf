########################################
# General vars
########################################
variable "enabled" {
  default     = true
  description = "Is this module enabled? If set to false, this will do nothing"
  type        = bool
}

variable "name" {
  default     = "cognitoauthorizer"
  description = "Name to prefix resources with"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to supported resources"
  type        = map(string)
}

########################################
# ELB Vars
########################################
variable "authenticated_path" {
  default     = "/*"
  description = "Path prefix to apply Cognito auth to"
  type        = string
}

variable "listener_arn" {
  description = "Listener to attach rule to"
  type        = string
}

variable "rule_priority" {
  default     = null
  description = "Rule priority to use. Must not already be in use by another rule on the listener. Omit to automatically place the rule."
  type        = number
}

variable "target_group_arn" {
  description = "Target group to forward authenticated requests to"
  type        = string
}

########################################
# Cognito vars
########################################

variable "auto_verified_attributes" {
  default     = ["email"]
  description = "The attribute to be auto-verified. Possible values: email, phone_number"
  type        = list(string)
}

variable "callback_urls" {
  description = "URLs that are associated with the load balancer (include protocol but not a trailing /)"
  type        = list(string)
}

variable "create_cognito_pool" {
  default     = true
  description = "Create a Cognito user pool? If false, `user_pool_arn`, `user_pool_client_id`, and `user_pool_domain` must be specified."
  type        = bool
}

variable "email_sending_account" {
  default     = "COGNITO_DEFAULT"
  description = "The email delivery method to use. COGNITO_DEFAULT for the default email functionality built into Cognito or DEVELOPER to use your Amazon SES configuration."
  type        = string
}

variable "email_source_arn" {
  default     = null
  description = "The ARN of the SES verified email identity to to use. Required if email_sending_account is set to DEVELOPER."
  type        = string
}

variable "mfa_configuration" {
  default     = "OFF"
  description = "(Default: OFF) Set to enable multifactor authentication. Must be one of the following values (ON, OFF, OPTIONAL)"
  type        = string
}

variable "password_minimum_length" {
  default     = "8" #tfsec:ignore:GEN001
  description = "The minimum length of the password policy that you have set"
  type        = string
}

variable "password_require_lowercase" {
  default     = true
  description = "Whether you have required users to use at least one lowercase letter in their password"
  type        = bool
}

variable "password_require_numbers" {
  default     = true
  description = "Whether you have required users to use at least one number in their password"
  type        = bool
}

variable "password_require_symbols" {
  default     = true
  description = "Whether you have required users to use at least on symbol in their password"
  type        = bool
}

variable "password_require_uppercase" {
  default     = true
  description = "Whether you have required users to use at least one uppercase letter in their password"
  type        = bool
}

variable "sms_authentication_message" {
  default     = "Your authentication code is {####}."
  description = "A string representing the SMS verification message. Conflicts with verification_message_template configuration block sms_message argument"
  type        = string
}

variable "temporary_password_validity_days" {
  default     = 14
  description = "The user account expiration limit, in days, after which the account is no longer usable"
  type        = number
}

variable "user_pool_arn" {
  default     = null
  description = "User Pool ARN for existing pool. Must be specified if `create_cognito_pool` is true"
  type        = string
}

variable "user_pool_client_id" {
  default     = null
  description = "User Pool Client ID for existing pool. Must be specified if `create_cognito_pool` is true"
  type        = string
}

variable "user_pool_domain" {
  default     = null
  description = "The domain string. Must be specified if `create_cognito_pool` is true"
  type        = string
}
