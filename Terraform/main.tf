terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
  }
}

# provider "aws" {
#   region = "${var.region}"   
# }

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "role" {
    name = "${var.prefix}-role"
    assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}
resource "aws_iam_group" "group" {
  name = "${var.prefix}-group"
}
