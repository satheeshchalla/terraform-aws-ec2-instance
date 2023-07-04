resource "aws_iam_role" "ec2_role" {
  count = var.iam_instance_profile == "" ? 1 : 0
  name  = "${var.name_prefix}-ec2-instance-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.iam_instance_profile == "" ? 1 : 0
  name  = "${var.name_prefix}-ec2-instance-profile"
  role  = aws_iam_role.ec2_role[0].name
}


locals {
  base_ec2_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

resource "aws_iam_role_policy_attachment" "attach_base_ec2_policies" {
  for_each   = toset([for p in local.base_ec2_policies : p if var.iam_instance_profile == ""])
  policy_arn = each.key
  role       = aws_iam_role.ec2_role[0].name

  # depends = [aws_iam_instance_profile.ec2_instance_profile]
}
