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

### Important: Secrets in Terraform State

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

## Known Issues

### "Block count changed" error

When applying the Terraform configuration, you'll see an error like:
```
Error: Provider produced inconsistent result after apply
.input: block count changed from 1 to 9
```

**What's happening**: The Azure integration in Fleet automatically creates all 9 available input types (eventhub, platformlogs, activitylogs, graphactivitylogs, springcloudlogs, events, adlogs, firewall_logs, application_gateway) even when you only define one in Terraform. The Terraform provider sees this as unexpected behavior and reports an error.

**Impact**: Despite the error message, the resources ARE created successfully and work correctly. This is a cosmetic issue with the provider, not a functional problem.

**Status**: This is a known bug tracked in [GitHub Issue #1078](https://github.com/elastic/terraform-provider-elasticstack/issues/1078)
