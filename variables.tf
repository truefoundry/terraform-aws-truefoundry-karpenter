variable "cluster_name" {
  description = "Cluster Name to install karpenter"
  type        = string
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
  description = "The initial node iam role arn"
  type        = string
}

variable "controller_nodegroup_name" {
  description = "The initial nodegroup name"
  type        = string
}
variable "sqs_enable_encryption" {
  description = "Enable Server side encryption for SQS"
  type = bool
  default = true
}

variable "message_retention_seconds" {
  description = "Message retention in seconds for SQS queue"
  type = number
  default = 300
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}