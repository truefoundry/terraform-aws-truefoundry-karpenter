# terraform-aws-truefoundry-karpenter
Truefoundry AWS Karpenter Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.57 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | ~> 20.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster Name to install karpenter | `string` | n/a | yes |
| <a name="input_controller_node_iam_role_arn"></a> [controller\_node\_iam\_role\_arn](#input\_controller\_node\_iam\_role\_arn) | The node iam role for the initial node group to be used by karpenter | `string` | n/a | yes |
| <a name="input_controller_nodegroup_name"></a> [controller\_nodegroup\_name](#input\_controller\_nodegroup\_name) | The initial nodegroup name | `string` | n/a | yes |
| <a name="input_create_karpenter_iam_role"></a> [create\_karpenter\_iam\_role](#input\_create\_karpenter\_iam\_role) | Enable/disable creation of IAM role for karpenter | `bool` | `true` | no |
| <a name="input_disable_default_tags"></a> [disable\_default\_tags](#input\_disable\_default\_tags) | Disable default tags for the resources created | `bool` | `false` | no |
| <a name="input_existing_karpenter_iam_role_arn"></a> [existing\_karpenter\_iam\_role\_arn](#input\_existing\_karpenter\_iam\_role\_arn) | ARN of the existing karpenter role. This will be used only when create\_karpenter\_iam\_role is set to false | `string` | `""` | no |
| <a name="input_existing_karpenter_instance_profile"></a> [existing\_karpenter\_instance\_profile](#input\_existing\_karpenter\_instance\_profile) | Instance profile for karpenter. This will be used only when create\_karpenter\_iam\_role is set to false | `string` | `""` | no |
| <a name="input_k8s_service_account_name"></a> [k8s\_service\_account\_name](#input\_k8s\_service\_account\_name) | The k8s karpenter service account name | `string` | `"karpenter"` | no |
| <a name="input_k8s_service_account_namespace"></a> [k8s\_service\_account\_namespace](#input\_k8s\_service\_account\_namespace) | The k8s karpenter namespace | `string` | `"kube-system"` | no |
| <a name="input_karpenter_iam_role_additional_policy_arns"></a> [karpenter\_iam\_role\_additional\_policy\_arns](#input\_karpenter\_iam\_role\_additional\_policy\_arns) | ARNs of additional policies to attach to the karpenter IAM role. For example {'x-policy' = arn:aws:iam::123456789012:policy/x-policy}) | `any` | `{}` | no |
| <a name="input_karpenter_iam_role_enable_override"></a> [karpenter\_iam\_role\_enable\_override](#input\_karpenter\_iam\_role\_enable\_override) | Enable/disable override of the node iam role for the initial node group to be used by karpenter. If this is set to true, the karpenter\_iam\_role\_override\_name will be used. | `bool` | `false` | no |
| <a name="input_karpenter_iam_role_name_prefix_enabled"></a> [karpenter\_iam\_role\_name\_prefix\_enabled](#input\_karpenter\_iam\_role\_name\_prefix\_enabled) | Boolean flag to enable/disable using name prefix for karpenter iam role | `bool` | `false` | no |
| <a name="input_karpenter_iam_role_override_name"></a> [karpenter\_iam\_role\_override\_name](#input\_karpenter\_iam\_role\_override\_name) | The name of the node iam role to be used by karpenter. This will be used only when karpenter\_iam\_role\_enable\_override is set to true | `string` | `""` | no |
| <a name="input_karpenter_iam_role_permissions_boundary_arn"></a> [karpenter\_iam\_role\_permissions\_boundary\_arn](#input\_karpenter\_iam\_role\_permissions\_boundary\_arn) | The permissions boundary ARN to be used by the karpenter IAM role | `string` | `""` | no |
| <a name="input_sqs_enable_encryption"></a> [sqs\_enable\_encryption](#input\_sqs\_enable\_encryption) | Enable Server side encryption for SQS | `bool` | `true` | no |
| <a name="input_sqs_enable_override"></a> [sqs\_enable\_override](#input\_sqs\_enable\_override) | Enable/disable override of the SQS queue name for karpenter spot interruption handling | `bool` | `false` | no |
| <a name="input_sqs_override_name"></a> [sqs\_override\_name](#input\_sqs\_override\_name) | Override name for the SQS queue created for karpenter spot interruption handling. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Tags common to all the resources created | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_karpenter_instance_profile_id"></a> [karpenter\_instance\_profile\_id](#output\_karpenter\_instance\_profile\_id) | Karpenter instance profile ID |
| <a name="output_karpenter_instance_profile_name"></a> [karpenter\_instance\_profile\_name](#output\_karpenter\_instance\_profile\_name) | Karpenter instance profile name |
| <a name="output_karpenter_role_arn"></a> [karpenter\_role\_arn](#output\_karpenter\_role\_arn) | Karpenter controller role ARN from the EKS karpenter sub-module |
| <a name="output_karpenter_sqs_arn"></a> [karpenter\_sqs\_arn](#output\_karpenter\_sqs\_arn) | SQS interruption queue ARN from the EKS karpenter sub-module |
| <a name="output_karpenter_sqs_name"></a> [karpenter\_sqs\_name](#output\_karpenter\_sqs\_name) | SQS interruption queue name from the EKS karpenter sub-module |
<!-- END_TF_DOCS -->