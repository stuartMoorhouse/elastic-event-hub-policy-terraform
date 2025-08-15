# Elastic Event Hub Policy Terraform

This repo contains Terraform scripts to set up an Azure Event Hub Integration in Elastic Fleet. It creates an Agent Policy, which contains the Event Hub Integration.

## Prerequisites

- Elasticsearch cluster with Fleet enabled
- API key with Fleet management permissions
- Azure Event Hub connection details

## Configuration

1. Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your actual values:
- `event_hub_name`: Your Azure Event Hub name
- `storage_account`: Azure storage account name for checkpointing
- `connection_string`: Event Hub connection string
- `storage_account_key`: Storage account access key
- `elasticsearch_api_key`: Elasticsearch API key
- `elasticsearch_endpoints`: Elasticsearch endpoint
- `fleet_endpoint`: Fleet endpoint

## Usage

```bash
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply configuration
terraform apply

# Destroy resources when done
terraform destroy
```

## Files

- `elastic-policy-integration.tf` - Main integration policy configuration
- `providers.tf` - Provider configuration
- `variables.tf` - Variable definitions
- `outputs.tf` - Output values
- `versions.tf` - Version constraints
- `terraform.tfvars.example` - Example variables file

## Security Notes

- Never commit `terraform.tfvars` with real credentials
- Use environment variables or secure secret management for production
- The `.gitignore` file is configured to exclude sensitive files

## Known Issues

- The Terraform provider may report "block count changed" errors when creating the Azure integration, but resources are created successfully
- The integration appears as "Azure Logs" in the UI because Event Hub is part of the broader Azure integration package
