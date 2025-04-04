output "karpenter_role_arn" {
  value       = var.create_karpenter_iam_role ? module.karpenter_irsa_role[0].iam_role_arn : var.existing_karpenter_iam_role_arn
  description = "Karpenter role ARN"
}

output "karpenter_instance_profile_id" {
  value       = var.create_karpenter_iam_role ? aws_iam_instance_profile.karpenter[0].id : ""
  description = "Karpenter instance profile ID"
}

output "karpenter_sqs_name" {
  value       = aws_sqs_queue.karpenter.name
  description = "Name of the SQS queue for interruption handling"
}