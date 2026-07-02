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
  value       = aws_appconfig_configuration_profile.configuration_profile.configuration_profile_id
}

output "arn" {
  description = "The ARN of the configuration profile."
  value       = aws_appconfig_configuration_profile.configuration_profile.arn
}

output "name" {
  description = "The name of the configuration profile."
  value       = aws_appconfig_configuration_profile.configuration_profile.name
}

output "application_id" {
  description = "The AppConfig application ID."
  value       = aws_appconfig_configuration_profile.configuration_profile.application_id
}

output "location_uri" {
  description = "The configuration source URI."
  value       = aws_appconfig_configuration_profile.configuration_profile.location_uri
}

output "type" {
  description = "The configuration profile type."
  value       = aws_appconfig_configuration_profile.configuration_profile.type
}

output "description" {
  description = "The configuration profile description."
  value       = aws_appconfig_configuration_profile.configuration_profile.description
}

output "kms_key_identifier" {
  description = "The KMS key identifier configured for hosted configuration data."
  value       = aws_appconfig_configuration_profile.configuration_profile.kms_key_identifier
}

output "retrieval_role_arn" {
  description = "The IAM role ARN AWS AppConfig assumes to retrieve external configuration."
  value       = aws_appconfig_configuration_profile.configuration_profile.retrieval_role_arn
}

output "validators" {
  description = "The configured validators for the configuration profile."
  value       = aws_appconfig_configuration_profile.configuration_profile.validator
}
