resource "aws_sqs_queue" "karpenter" {
  name                      = "${var.cluster_name}-karpenter"
  message_retention_seconds = var.message_retention_seconds
  sqs_managed_sse_enabled = var.sqs_enable_encryption
  tags = local.tags
}

data "aws_iam_policy_document" "sqs" {
  statement {
    resources = [aws_sqs_queue.karpenter.arn]
    actions   = ["sqs:DeleteMessage", "sqs:GetQueueUrl", "sqs:GetQueueAttributes", "sqs:ReceiveMessage"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "sqs" {
  name_prefix = "${var.cluster_name}-karpenter-access-to-sqs"
  description = "Access policy for karpenter to access SQS for ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.sqs.json
  tags        = local.tags
}

resource "aws_sqs_queue_policy" "karpenter" {
  policy    = data.aws_iam_policy_document.node_termination_queue.json
  queue_url = aws_sqs_queue.karpenter.url
}

data "aws_iam_policy_document" "node_termination_queue" {
  statement {
    resources = [aws_sqs_queue.karpenter.arn]
    sid       = "SQSWrite"
    actions   = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for k, v in local.events : k => v }

  name_prefix   = substr("${var.cluster_name}-${each.value.name}-", 0, 37)
  description   = each.value.description
  event_pattern = jsonencode(each.value.event_pattern)

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = { for k, v in local.events : k => v }

  rule      = aws_cloudwatch_event_rule.this[each.key].name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.karpenter.arn
}