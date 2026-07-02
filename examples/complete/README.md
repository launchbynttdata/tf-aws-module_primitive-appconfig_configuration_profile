# Complete Example

This example creates a complete AppConfig configuration profile deployment with the dependencies required to exercise the primitive module.

## Usage

```hcl
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "appconfig_kms" {
  statement {
    sid     = "EnableAccountAdministration"
    effect  = "Allow"
    actions = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }

  statement {
    sid    = "AllowAppConfigUse"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
    ]
    principals {
      type        = "Service"
      identifiers = ["appconfig.amazonaws.com"]
    }
    resources = ["*"]
  }
}

resource "aws_kms_key" "appconfig" {
  description         = "KMS key for AppConfig hosted configuration data"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.appconfig_kms.json
  tags                = merge(var.tags, { Name = module.resource_names["kms_key"].standard })
}



module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  cloud_resource_type     = each.value.name
  maximum_length          = each.value.max_length

  region = join("", split("-", data.aws_region.current.region))
}

resource "aws_appconfig_application" "example" {
  name = module.resource_names["application"].standard
  tags = var.tags
}

module "configuration_profile" {
  source = "../.."

  application_id = aws_appconfig_application.example.id
  name           = module.resource_names["configuration_profile"].standard
  description    = var.description
  location_uri   = var.location_uri
  type           = var.type
  validators     = []
  tags           = var.tags
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.100, < 7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_configuration_profile"></a> [configuration\_profile](#module\_configuration\_profile) | ../.. | n/a |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_appconfig_application.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_application) | resource |
| [aws_kms_key.appconfig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.appconfig_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Environment class for generated resource names. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Configuration profile description. | `string` | `"Example hosted feature flag profile."` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Environment instance number for generated resource names. | `number` | n/a | yes |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Resource instance number for generated resource names. | `number` | n/a | yes |
| <a name="input_location_uri"></a> [location\_uri](#input\_location\_uri) | Configuration source URI. | `string` | `"hosted"` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Logical product family for generated resource names. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Logical product service for generated resource names. | `string` | n/a | yes |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | Resource name configuration keyed by resource role. | <pre>map(object({<br/>    name       = string<br/>    max_length = number<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Configuration profile type. | `string` | `"AWS.AppConfig.FeatureFlags"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_id"></a> [application\_id](#output\_application\_id) | The application ID. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the configuration profile. |
| <a name="output_expected_kms_key_arn"></a> [expected\_kms\_key\_arn](#output\_expected\_kms\_key\_arn) | Expected KMS key ARN. |
| <a name="output_expected_kms_key_identifier"></a> [expected\_kms\_key\_identifier](#output\_expected\_kms\_key\_identifier) | Expected KMS key identifier. |
| <a name="output_expected_location_uri"></a> [expected\_location\_uri](#output\_expected\_location\_uri) | Expected location URI. |
| <a name="output_expected_name"></a> [expected\_name](#output\_expected\_name) | Expected configuration profile name. |
| <a name="output_expected_type"></a> [expected\_type](#output\_expected\_type) | Expected profile type. |
| <a name="output_id"></a> [id](#output\_id) | The configuration profile ID. |
| <a name="output_location_uri"></a> [location\_uri](#output\_location\_uri) | The configuration source URI. |
| <a name="output_name"></a> [name](#output\_name) | The name of the configuration profile. |
| <a name="output_region"></a> [region](#output\_region) | The AWS Region where the example resources are deployed. |
| <a name="output_type"></a> [type](#output\_type) | The configuration profile type. |
<!-- END_TF_DOCS -->
