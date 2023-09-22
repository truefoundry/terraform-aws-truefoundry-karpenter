# terraform-aws-truefoundry-karpenter
Truefoundry AWS Karpenter Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.17.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_karpenter_irsa_role"></a> [karpenter\_irsa\_role](#module\_karpenter\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.27.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.karpenter](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/iam_instance_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster Name to install karpenter | `string` | n/a | yes |
| <a name="input_controller_node_iam_role_arn"></a> [controller\_node\_iam\_role\_arn](#input\_controller\_node\_iam\_role\_arn) | The initial node iam role arn | `string` | n/a | yes |
| <a name="input_controller_nodegroup_name"></a> [controller\_nodegroup\_name](#input\_controller\_nodegroup\_name) | The initial nodegroup name | `string` | n/a | yes |
| <a name="input_k8s_service_account_name"></a> [k8s\_service\_account\_name](#input\_k8s\_service\_account\_name) | The k8s karpenter service account name | `string` | n/a | yes |
| <a name="input_k8s_service_account_namespace"></a> [k8s\_service\_account\_namespace](#input\_k8s\_service\_account\_namespace) | The k8s karpenter namespace | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | The oidc provider  arn of the eks cluster | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Tags common to all the resources created | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_karpenter_instance_profile_id"></a> [karpenter\_instance\_profile\_id](#output\_karpenter\_instance\_profile\_id) | n/a |
| <a name="output_karpenter_role_arn"></a> [karpenter\_role\_arn](#output\_karpenter\_role\_arn) | n/a |
<!-- END_TF_DOCS -->