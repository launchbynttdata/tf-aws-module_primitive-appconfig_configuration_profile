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

output "id" {
  description = "The configuration profile ID."
  value       = module.configuration_profile.id
}
output "arn" {
  description = "The ARN of the configuration profile."
  value       = module.configuration_profile.arn
}
output "name" {
  description = "The name of the configuration profile."
  value       = module.configuration_profile.name
}
output "application_id" {
  description = "The application ID."
  value       = module.configuration_profile.application_id
}
output "location_uri" {
  description = "The configuration source URI."
  value       = module.configuration_profile.location_uri
}
output "type" {
  description = "The configuration profile type."
  value       = module.configuration_profile.type
}
output "expected_name" {
  description = "Expected configuration profile name."
  value       = module.resource_names["configuration_profile"].standard
}
output "expected_location_uri" {
  description = "Expected location URI."
  value       = var.location_uri
}
output "expected_type" {
  description = "Expected profile type."
  value       = var.type
}

output "region" {
  description = "The AWS Region where the example resources are deployed."
  value       = data.aws_region.current.region
}

output "expected_kms_key_arn" {
  description = "Expected KMS key ARN."
  value       = aws_kms_key.appconfig.arn
}

output "expected_kms_key_identifier" {
  description = "Expected KMS key identifier."
  value       = aws_kms_key.appconfig.arn
}

output "kms_key_identifier" {
  description = "The KMS key identifier configured for hosted configuration data."
  value       = module.configuration_profile.kms_key_identifier
}
