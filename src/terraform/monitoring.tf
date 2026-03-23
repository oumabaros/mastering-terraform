resource "aws_iam_role" "vpc" {
  name               = "${var.application_name}-${var.environment_name}-network"
  assume_role_policy = data.aws_iam_policy_document.vpc_assume_role.json
}

resource "aws_iam_role_policy" "cloudwatch" {
  name   = "${var.application_name}-${var.environment_name}-network-cloudwatch"
  role   = aws_iam_role.vpc.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_cloudwatch_log_group" "vpc" {
  name = "${var.application_name}-${var.environment_name}-network"
}

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc.arn
  log_destination = aws_cloudwatch_log_group.vpc.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}
