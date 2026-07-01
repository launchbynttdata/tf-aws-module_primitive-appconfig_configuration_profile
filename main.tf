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

resource "aws_appconfig_configuration_profile" "configuration_profile" {
  application_id     = var.application_id
  name               = var.name
  location_uri       = var.location_uri
  description        = var.description
  kms_key_identifier = var.kms_key_identifier
  region             = var.region
  retrieval_role_arn = var.retrieval_role_arn
  tags               = var.tags
  type               = var.type

  dynamic "validator" {
    for_each = var.validators
    content {
      type    = validator.value.type
      content = validator.value.content
    }
  }
}
