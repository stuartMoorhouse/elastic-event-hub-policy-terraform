output "agent_policy_id" {
  description = "The ID of the created agent policy"
  value       = elasticstack_fleet_agent_policy.azure.policy_id
}

output "integration_policy_id" {
  description = "The ID of the created integration policy"
  value       = elasticstack_fleet_integration_policy.event_hub_policy.policy_id
}

output "enrollment_token" {
  description = "The enrollment token for the agent policy"
  value       = data.elasticstack_fleet_enrollment_tokens.token.tokens
  sensitive   = true
}