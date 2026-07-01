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

# -----------------------------------------------------------------------------
# Required
# -----------------------------------------------------------------------------

variable "application_id" {
  description = "AppConfig application ID."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{4,7}$", var.application_id))
    error_message = "application_id must match ^[a-z0-9]{4,7}$."
  }
}

variable "name" {
  description = "Name of the AppConfig configuration profile. Must be 1 to 64 characters."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "Name must be between 1 and 64 characters."
  }
}

variable "location_uri" {
  description = "URI of the configuration source. Use hosted for AWS AppConfig hosted configurations."
  type        = string
  validation {
    condition     = length(var.location_uri) >= 1 && length(var.location_uri) <= 2048
    error_message = "location_uri must be between 1 and 2048 characters."
  }
}

# -----------------------------------------------------------------------------
# Optional
# -----------------------------------------------------------------------------

variable "description" {
  description = "Description of the AppConfig configuration profile. Must be at most 1024 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null ? true : length(var.description) <= 1024
    error_message = "Description must be at most 1024 characters."
  }
}

variable "kms_key_identifier" {
  description = "KMS key identifier for encrypting hosted configuration data."
  type        = string
  default     = null
}
variable "retrieval_role_arn" {
  description = "IAM role ARN AWS AppConfig assumes to retrieve configuration from external sources."
  type        = string
  default     = null
}
variable "type" {
  description = "Configuration profile type. Use AWS.AppConfig.FeatureFlags for hosted feature flag documents."
  type        = string
  default     = null
}
variable "validators" {
  description = "Validators for the configuration profile. Maximum of 2 validators. Valid validator types are JSON_SCHEMA and LAMBDA. content is required by AWS for JSON_SCHEMA validators."
  type        = list(object({ type = string, content = optional(string) }))
  default     = []
  validation {
    condition     = length(var.validators) <= 2
    error_message = "At most 2 validators may be configured."
  }
  validation {
    condition     = alltrue([for validator in var.validators : contains(["JSON_SCHEMA", "LAMBDA"], validator.type)])
    error_message = "Validator type must be JSON_SCHEMA or LAMBDA."
  }
}

variable "region" {
  description = "AWS Region where this resource is managed. Defaults to the provider-configured Region."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. Up to 50 tags are allowed; tag keys must be 1 to 128 characters and values must be at most 256 characters."
  type        = map(string)
  default     = {}

  validation {
    condition = length(var.tags) <= 50 && alltrue([
      for key, value in var.tags : length(key) >= 1 && length(key) <= 128 && length(value) <= 256
    ])
    error_message = "Tags must contain at most 50 entries. Tag keys must be 1 to 128 characters and values must be at most 256 characters."
  }
}
