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

### ⚠️ Important: Secrets in Terraform State

The Elastic Terraform provider currently stores secrets (connection strings, storage account keys) in **plain text** in the Terraform state file, even though they are properly secured in Elasticsearch/Kibana. This is a known limitation tracked in [GitHub Issue #689](https://github.com/elastic/terraform-provider-elasticstack/issues/689) and [Issue #1232](https://github.com/elastic/terraform-provider-elasticstack/issues/1232).

**What happens:**
1. Terraform sends plain text secrets to the Fleet API
2. Fleet API creates secure secret references in Elasticsearch
3. Secrets are properly hidden in Kibana UI
4. BUT Terraform state file contains the secrets in plain text

**Recommendations:**
- Use a remote backend with encryption (e.g., S3 with SSE-KMS, Azure Storage with encryption)
- Restrict access to state files using IAM/RBAC
- Never commit `terraform.tfstate` files to version control
- Consider using external secret management systems where possible

### General Security Best Practices

- Never commit `terraform.tfvars` with real credentials
- The `.gitignore` file is configured to exclude sensitive files

## Known Issues

- The Terraform provider may report "block count changed" errors when creating the Azure integration, but resources are created successfully
- The integration appears as "Azure Logs" in the UI because Event Hub is part of the broader Azure integration package
