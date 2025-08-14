# Elastic Event Hub Policy Terraform

This Terraform configuration creates an Azure Event Hub integration in Elastic Fleet.

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

The `api-transform.py` script can convert Elastic Fleet API calls to Terraform configuration:

```bash
# Place your API call in api-call.json
python3 api-transform.py
```

This will generate the input blocks needed for the Terraform configuration.

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
