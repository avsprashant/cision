terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
  }
}

#sample policy doc
data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

# create a role
resource "aws_iam_role" "role" {
    name = "${var.prefix}-role"
    assume_role_policy = data.aws_iam_policy_document.example.json
}

# #to fetch arn of iam role
# data "aws_iam_role" "role" {
#   name = "${var.prefix}-role"
# }

#policy which allows to assume above role
resource "aws_iam_policy" "policy" {
  name        = "${var.prefix}-policy"
  path        = "/"
  description = "Assume policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.role.arn
      },
    ]
  })
}

#creating user and group and adding user to group
resource "aws_iam_group" "group" {
  name = "${var.prefix}-group"
}

resource "aws_iam_user" "user" {
  name = "${var.prefix}-user"
}

resource "aws_iam_user_group_membership" "membership" {
  user = aws_iam_user.user.name

  groups = [
    aws_iam_group.group.name,
  ]
}

#adding policy to a group
resource "aws_iam_group_policy_attachment" "policy_attachment" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}