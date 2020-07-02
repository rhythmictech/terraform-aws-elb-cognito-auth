resource "aws_security_group" "this" {
  name_prefix = "example"
  description = "SG for ELB"
  vpc_id      = "vpc-0123456789"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all_to_alb_https" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  description       = "Allow inbound access to the ELB"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 443
  type              = "ingress"
}

# The ELB must be able to communicate to Cognito on port 443
resource "aws_security_group_rule" "allow_lb_to_cognito" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  description       = "Allow LB access to Cognito"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 443
  type              = "egress"
}

resource "aws_security_group_rule" "allow_lb_to_vpc" {
  cidr_blocks       = ["172.16.20.0/22"]
  description       = "Allow LB access to HTTP within the VPC"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 80
  type              = "egress"
}

resource "aws_lb" "this" {
  name_prefix        = "exampl"
  internal           = false #tfsec:ignore:AWS005
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = ["subnet-012345789", "subnet-123457890"]
}

data "aws_acm_certificate" "this" {
  domain   = "mysite.com"
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "this" {
  certificate_arn   = data.aws_acm_certificate.this.arn
  load_balancer_arn = aws_lb.this.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = aws_lb_target_group.this.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "this" {
  name_prefix = "exampl"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0123456789"

  lifecycle {
    create_before_destroy = true
  }

}

data "aws_route53_zone" "this" {
  name = "mysite.com."
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "aliasformyelb.mysite.com"
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

module "cognitoauth" {
  source = "../../"

  name             = "example"
  callback_urls    = ["https://aliasformyelb.mysite.com/"]
  listener_arn     = aws_lb_listener.this.arn
  target_group_arn = aws_lb_target_group.this.id
  user_pool_domain = "aliasformyelb"
}
