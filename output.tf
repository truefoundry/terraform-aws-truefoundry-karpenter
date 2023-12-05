output "karpenter_role_arn" {
  value = module.karpenter_irsa_role.iam_role_arn
  description = "Karpenter role ARN"
}

output "karpenter_instance_profile_id" {
  value = aws_iam_instance_profile.karpenter.id
  description = "Karpenter instance profile ID"
}

output "karpenter_sqs_name" {
  value = aws_sqs_queue.karpenter.name
  description = "Name of the SQS queue for interruption handling"
}