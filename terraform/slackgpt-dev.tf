# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

data "jinja_template" "account_email" {
  template = var.account_email_template
  context {
    data = jsonencode({
      account_name = "slackgpt-dev"
    })
    type = "json"
  }
}

module "slackgpt-dev" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail = data.jinja_template.account_email.result
    AccountName  = "slackgpt-dev"
    # Syntax for top-level OU
    ManagedOrganizationalUnit = "Deployments"
    # Syntax for nested OU
    # ManagedOrganizationalUnit = "Sandbox (ou-xfe5-a8hb8ml8)"
    SSOUserEmail     = data.jinja_template.account_email.result
    SSOUserFirstName = "Paul"
    SSOUserLastName  = "Nickerson"
  }
  account_tags = {
    "environment" = "Dev"
  }

}
