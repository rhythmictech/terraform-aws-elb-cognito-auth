locals {

  # Determine whether some or all resources will be created
  create_rule              = var.enabled
  create_cognito_resources = var.enabled && var.create_cognito_pool

  # Set values for Cognito user pool
  callback_urls       = formatlist("%soauth2/idpresponse", var.callback_urls)
  user_pool_arn       = var.create_cognito_pool ? aws_cognito_user_pool.this[0].arn : var.user_pool_arn
  user_pool_client_id = var.create_cognito_pool ? aws_cognito_user_pool_client.this[0].id : var.user_pool_client_id
  user_pool_domain    = var.create_cognito_pool ? aws_cognito_user_pool_domain.this[0].domain : var.user_pool_domain
}

resource "aws_lb_listener_rule" "this" {
  count = local.create_rule ? 1 : 0

  listener_arn = var.listener_arn
  priority     = var.rule_priority

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      scope               = "openid"
      user_pool_arn       = local.user_pool_arn
      user_pool_client_id = local.user_pool_client_id
      user_pool_domain    = local.user_pool_domain
    }
  }

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = [var.authenticated_path]
    }
  }
}

resource "aws_cognito_user_pool" "this" {
  count = local.create_cognito_resources ? 1 : 0

  name                       = var.name
  auto_verified_attributes   = var.auto_verified_attributes
  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.sms_authentication_message
  tags                       = var.tags

  email_configuration {
    email_sending_account = var.email_sending_account
    source_arn            = var.email_source_arn
  }

  password_policy {
    minimum_length                   = var.password_minimum_length
    require_uppercase                = var.password_require_uppercase
    require_lowercase                = var.password_require_lowercase
    require_numbers                  = var.password_require_numbers
    require_symbols                  = var.password_require_symbols
    temporary_password_validity_days = var.temporary_password_validity_days
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "Your verification code is {####}."
    email_subject        = "Your verification code"
    sms_message          = "Your verification code is {####}."
  }
}

resource "aws_cognito_user_pool_domain" "this" {
  count = local.create_cognito_resources ? 1 : 0

  domain       = var.user_pool_domain
  user_pool_id = aws_cognito_user_pool.this[0].id
}

resource "aws_cognito_user_pool_client" "this" {
  count = local.create_cognito_resources ? 1 : 0

  name                                 = var.name
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["openid"]
  callback_urls                        = local.callback_urls
  generate_secret                      = true
  supported_identity_providers         = ["COGNITO"]
  user_pool_id                         = aws_cognito_user_pool.this[0].id
}
