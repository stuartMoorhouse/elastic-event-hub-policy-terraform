// The integration to use.
resource "elasticstack_fleet_integration" "azure_event_hub" {
  name    = "azure"
  version = "1.28.1"
  force   = true
}

// An agent policy to hold the integration policy.
resource "elasticstack_fleet_agent_policy" "azure" {
  name            = var.agent_policy_name
  namespace       = "default"
  description     = var.agent_policy_description
  monitor_logs    = false
  monitor_metrics = false
  skip_destroy    = false
}

// The associated enrollment token.
data "elasticstack_fleet_enrollment_tokens" "token" {
  policy_id = elasticstack_fleet_agent_policy.azure.policy_id
}

// The integration policy.
resource "elasticstack_fleet_integration_policy" "event_hub_policy" {
  name                = "Azure Event Hub"
  namespace           = "default"
  description         = "Integration for Azure Event Hub"
  agent_policy_id     = elasticstack_fleet_agent_policy.azure.policy_id
  integration_name    = elasticstack_fleet_integration.azure_event_hub.name
  integration_version = elasticstack_fleet_integration.azure_event_hub.version


  input {
    input_id = "eventhub-azure-eventhub"
    enabled = true
    streams_json = jsonencode({
      "azure.eventhub" : {
        "enabled" : true,
        "vars" : {
          "parse_message" : false,
          "preserve_original_event" : false,
          "data_stream.dataset" : "azure.eventhub",
          "tags" : [
            "azure-eventhub",
            "forwarded"
          ],
          "sanitize_newlines" : false,
          "sanitize_singlequotes" : false
        }
      }
    })
  }


  vars_json = jsonencode({
    "eventhub" : var.event_hub_name,
    "consumer_group" : var.consumer_group,
    "connection_string" : var.connection_string,
    "storage_account" : var.storage_account,
    "storage_account_key" : var.storage_account_key
  })
}