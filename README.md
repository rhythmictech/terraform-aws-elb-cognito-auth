# terraform-aws-elb-cognito-auth

[![tflint](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/workflows/tflint/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/actions?query=workflow%3Atflint+event%3Apush+branch%3Amain)
[![tfsec](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/workflows/tfsec/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amain)
[![yamllint](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/workflows/yamllint/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amain)
[![misspell](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/workflows/misspell/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amain)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/workflows/pre-commit-check/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-elb-cognito-auth/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amain)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=RhythmicTech" alt="follow on Twitter"></a>

This module creates an ALB listener rule that is configured for Cognito authentication using a local user pool. It can also be used with a supplied Cognito user pool allowing for greater customizability. This module is meant to be a better solution when you need to protect web assets and don't want to use server-side HTTP basic authentication (e.g., to keep the general public out of a staging site). Among other benefits, this means your backend configuration does not have to change to restrict access and also means that users can have individual usernames/passwords that they can perform account resets on.

## Example
Here's what using the module will look like
```hcl
module "cognitoauth" {
  source           = "rhythmictech/aws/elb-cognito-auth

  name             = "example"
  callback_urls    = ["https://aliasformyelb.mysite.com/"]
  listener_arn     = aws_lb_listener.this.arn
  target_group_arn = aws_lb_target_group.this.id
  user_pool_domain = "aliasformyelb"
}

```

## Warning
The ELB security group must allow outbound HTTPS access so that it can talk to Cognito. This also requires any other relevant routing rules to be in place, such as NACLs. 

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.19 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| callback\_urls | URLs that are associated with the load balancer (include protocol but not a trailing /) | `list(string)` | n/a | yes |
| listener\_arn | Listener to attach rule to | `string` | n/a | yes |
| target\_group\_arn | Target group to forward authenticated requests to | `string` | n/a | yes |
| authenticated\_path | Path prefix to apply Cognito auth to | `string` | `"/*"` | no |
| auto\_verified\_attributes | The attribute to be auto-verified. Possible values: email, phone\_number | `list(string)` | <pre>[<br>  "email"<br>]</pre> | no |
| create\_cognito\_pool | Create a Cognito user pool? If false, `user_pool_arn`, `user_pool_client_id`, and `user_pool_domain` must be specified. | `bool` | `true` | no |
| email\_sending\_account | The email delivery method to use. COGNITO\_DEFAULT for the default email functionality built into Cognito or DEVELOPER to use your Amazon SES configuration. | `string` | `"COGNITO_DEFAULT"` | no |
| email\_source\_arn | The ARN of the SES verified email identity to to use. Required if email\_sending\_account is set to DEVELOPER. | `string` | `null` | no |
| enabled | Is this module enabled? If set to false, this will do nothing | `bool` | `true` | no |
| mfa\_configuration | (Default: OFF) Set to enable multifactor authentication. Must be one of the following values (ON, OFF, OPTIONAL) | `string` | `"OFF"` | no |
| name | Name to prefix resources with | `string` | `"cognitoauthorizer"` | no |
| password\_minimum\_length | The minimum length of the password policy that you have set | `string` | `"8"` | no |
| password\_require\_lowercase | Whether you have required users to use at least one lowercase letter in their password | `bool` | `true` | no |
| password\_require\_numbers | Whether you have required users to use at least one number in their password | `bool` | `true` | no |
| password\_require\_symbols | Whether you have required users to use at least on symbol in their password | `bool` | `true` | no |
| password\_require\_uppercase | Whether you have required users to use at least one uppercase letter in their password | `bool` | `true` | no |
| rule\_priority | Rule priority to use. Must not already be in use by another rule on the listener. Omit to automatically place the rule. | `number` | `null` | no |
| sms\_authentication\_message | A string representing the SMS verification message. Conflicts with verification\_message\_template configuration block sms\_message argument | `string` | `"Your authentication code is {####}."` | no |
| tags | Tags to apply to supported resources | `map(string)` | `{}` | no |
| temporary\_password\_validity\_days | The user account expiration limit, in days, after which the account is no longer usable | `number` | `14` | no |
| user\_pool\_arn | User Pool ARN for existing pool. Must be specified if `create_cognito_pool` is true | `string` | `null` | no |
| user\_pool\_client\_id | User Pool Client ID for existing pool. Must be specified if `create_cognito_pool` is true | `string` | `null` | no |
| user\_pool\_domain | The domain string. Must be specified if `create_cognito_pool` is true | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| lb\_listener\_rule\_arn | AWS LB Listener Rule ARN |
| user\_pool\_arn | Cognito User Pool ARN (will return the user provided ARN if `create_cognito_pool = false`) |
| user\_pool\_client\_id | Cognito User Pool ARN (will return the user provided ARN if `create_cognito_pool = false`) |
| user\_pool\_domain | Cognito User Pool ARN (will return the user provided ARN if `create_cognito_pool = false`) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
