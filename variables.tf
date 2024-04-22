variable "cluster_name" {
  description = "Cluster Name to install karpenter"
  type        = string
}

variable "additional_karpenter_controller_role_policies_arn" {
  description = "arn of dditional policies to attach to the karpenter controller role (Example {'x-policy' = arn:aws:iam::123456789012:policy/x-policy})"
  type        = any
  default     = {}
}

variable "k8s_service_account_name" {
  description = "The k8s karpenter service account name"
  type        = string
}

variable "k8s_service_account_namespace" {
  description = "The k8s karpenter namespace"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The oidc provider  arn of the eks cluster"
  type        = string
}

variable "controller_node_iam_role_arn" {
  description = "The node iam role for the initial node group to be used by karpenter"
  type        = string
}

variable "additional_controller_node_iam_role_arns" {
  description = "The additional node iam roles to be used by karpenter"
  type        = list(string)
  default     = []
}

variable "controller_nodegroup_name" {
  description = "The initial nodegroup name"
  type        = string
}

variable "sqs_enable_encryption" {
  description = "Enable Server side encryption for SQS"
  type        = bool
  default     = true
}

variable "message_retention_seconds" {
  description = "Message retention in seconds for SQS queue"
  type        = number
  default     = 300
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}