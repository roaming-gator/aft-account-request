# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

data "jinja_template" "slackgpt-test-email" {
  template = var.account_email_template
  context {
    data = jsonencode({
      account_name = "slackgpt-test"
    })
    type = "json"
  }
}

module "slackgpt-test" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail = data.jinja_template.slackgpt-test-email.result
    AccountName  = "slackgpt-test"
    # Syntax for top-level OU
    ManagedOrganizationalUnit = "Deployments"
    # Syntax for nested OU
    SSOUserEmail     = data.jinja_template.slackgpt-test-email.result
    SSOUserFirstName = "Paul"
    SSOUserLastName  = "Nickerson"
  }
  change_management_parameters = {
    change_requested_by = "Paul Nickerson"
    change_reason       = "Slackgpt test deployment"
  }
  account_tags = {
    "environment" = "test"
  }

  account_customizations_name = "slackgpt"
}
