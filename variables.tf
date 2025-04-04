variable "cluster_name" {
  description = "Cluster Name to install karpenter"
  type        = string
}

variable "k8s_service_account_name" {
  description = "The k8s karpenter service account name"
  type        = string
  default     = "karpenter"
}

variable "k8s_service_account_namespace" {
  description = "The k8s karpenter namespace"
  type        = string
  default     = "kube-system"
}

variable "create_karpenter_iam_role" {
  description = "Enable/disable creation of IAM role for karpenter"
  type        = bool
  default     = true
}

variable "existing_karpenter_iam_role_arn" {
  description = "ARN of the existing karpenter role. This will be used only when create_karpenter_iam_role is set to false"
  type        = string
  default     = ""
}

variable "existing_karpenter_instance_profile" {
  description = "Instance profie for karpenter. This will be used only when create_karpenter_iam_role is set to false"
  type        = string
  default     = ""
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

variable "additional_controller_role_policies_arn" {
  description = "arn of dditional policies to attach to the karpenter controller role (Example {'x-policy' = arn:aws:iam::123456789012:policy/x-policy})"
  type        = any
  default     = {}
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