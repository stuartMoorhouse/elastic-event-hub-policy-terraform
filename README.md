# Elastic Event Hub Policy Terraform

This repo contains Terraform configuration to set up Azure Event Hub log ingestion in Elastic Fleet. It automates the creation of agent policies and integration policies that would normally be configured manually through Kibana.

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
- `elasticsearch_api_key`: Base64-encoded Elasticsearch API key
- `elasticsearch_endpoints`: Elasticsearch cluster endpoint
- `fleet_endpoint`: Fleet/Kibana endpoint

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

## API Call Transformation

The `api-transform.py` script converts Fleet API calls (captured from Kibana's network inspector) into Terraform HCL format. This is useful when you've configured an integration in the Kibana UI and want to recreate it as infrastructure-as-code.

```bash
# Place your API call JSON in api-call.json
python3 api-transform.py
```

The script handles the translation of Kibana's JSON structure to Terraform's HCL syntax, including proper handling of secrets and variable references.

## Files

- `elastic-policy-integration.tf` - Main integration policy configuration
- `providers.tf` - Provider configuration
- `variables.tf` - Variable definitions
- `outputs.tf` - Output values
- `versions.tf` - Version constraints
- `api-transform.py` - Utility to transform API calls to Terraform

## Security Notes

- Never commit `terraform.tfvars` with real credentials
- Use environment variables or secure secret management for production
- The `.gitignore` file is configured to exclude sensitive files

## Known Issues

- The Terraform provider may report "block count changed" errors when creating the Azure integration, but resources are created successfully
- The integration appears as "Azure Logs" in the UI because Event Hub is part of the broader Azure integration package
