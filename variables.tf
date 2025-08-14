
variable "elasticsearch_api_key" {
  description = "Elasticsearch API key (base64 encoded)"
  type        = string
  sensitive   = true
}

variable "elasticsearch_endpoints" {
  description = "Elasticsearch cluster endpoints"
  type        = string
  default     = "http://localhost:9200"
}

variable "fleet_endpoint" {
  description = "Fleet server endpoint"
  type        = string
}

variable "agent_policy_name" {
  description = "Elasticsearch Policy"
  type        = string
  default     = "test policy"
}

variable "agent_policy_description" {
  description = "Elasticsearch Policy Description"
  type        = string
  default     = "Test policy description"
}

variable "event_hub_name" {
  description = "Name of the Event Hub"
  type        = string
  default     = "sm-test-event-hub"
}

variable "consumer_group" {
  description = "Event Hub consumer group"
  type        = string
  default     = "$Default"
}

variable "connection_string" {
  description = "Connection string"
  type        = string
  sensitive   = true
}

variable "storage_account" {
  description = "Storage account name"
  type        = string
  default     = "smtesteventhubstorage"
}

variable "storage_account_key" {
  description = "Storage account key"
  type        = string
  sensitive   = true
}