import json
import sys

def transform_vars(vars_dict):
    """Transform vars dict, converting secret references to plain strings"""
    transformed = {}
    for key, value in vars_dict.items():
        if isinstance(value, dict) and 'isSecretRef' in value:
            # For Terraform, we need to reference the actual secret value, not the ID
            # You'll need to replace these with actual values or variable references
            if key == "connection_string":
                transformed[key] = "${var.connection_string}"
            elif key == "storage_account_key":
                transformed[key] = "${var.storage_account_key}"
            else:
                transformed[key] = f"${{var.{key}}}"
        else:
            transformed[key] = value
    return transformed

def json_to_hcl_jsonencode(data, indent_level=2):
    """Convert Python dict to HCL jsonencode format"""
    json_str = json.dumps(data, indent=2)
    # Indent the JSON properly for HCL
    lines = json_str.split('\n')
    indented_lines = []
    base_indent = "  " * indent_level
    for i, line in enumerate(lines):
        if i == 0:
            indented_lines.append(line)
        else:
            indented_lines.append(base_indent + line)
    return "jsonencode(" + '\n' + base_indent + '\n'.join(indented_lines) + '\n' + base_indent + ")"

# Load the API call JSON
try:
    with open('api-call.json', 'r') as f:
        api_call_dict = json.load(f)
except FileNotFoundError:
    print("Error: api-call.json file not found")
    sys.exit(1)

# Extract inputs
api_call_dict_inputs = api_call_dict.get('inputs', {})
hcl_input_blocks = []

# Process each input
for input_name, input_block in api_call_dict_inputs.items():
    if input_block.get("enabled", False):
        # Create the input block
        input_hcl = f"""  input {{
    input_id = "{input_name}"
    enabled = true
    streams_json = {json_to_hcl_jsonencode(input_block.get("streams", {}), indent_level=3)}
  }}"""
        hcl_input_blocks.append(input_hcl)

# Process vars if they exist
vars_block = ""
if "vars" in api_call_dict:
    transformed_vars = transform_vars(api_call_dict["vars"])
    vars_block = f"""
  vars_json = {json_to_hcl_jsonencode(transformed_vars, indent_level=2)}"""

# Combine all blocks
final_output = '\n\n'.join(hcl_input_blocks)
if vars_block:
    final_output += vars_block

print("Generated Terraform HCL:")
print("-" * 50)
print(final_output)
print("-" * 50)

# Write to file
with open('input.txt', 'w') as f:
    f.write(final_output)

print("\nOutput written to input.txt")

# Also create a complete example of the integration policy resource
example_resource = f"""# Example complete resource (for reference)
resource "elasticstack_fleet_integration_policy" "event_hub_policy" {{
  name                = "Azure Event Hub"
  namespace           = "default"
  description         = "Integration for Azure Event Hub"
  agent_policy_id     = elasticstack_fleet_agent_policy.azure.policy_id
  integration_name    = elasticstack_fleet_integration.azure_event_hub.name
  integration_version = elasticstack_fleet_integration.azure_event_hub.version

{final_output}
}}"""

with open('example_resource.tf', 'w') as f:
    f.write(example_resource)

print("Example complete resource written to example_resource.tf")