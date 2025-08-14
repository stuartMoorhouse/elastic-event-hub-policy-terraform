
provider "elasticstack" {
  elasticsearch {
    api_key   = var.elasticsearch_api_key 
    endpoints = [var.elasticsearch_endpoints]
  }
  kibana {
    api_key   = var.elasticsearch_api_key
    endpoints = [var.elasticsearch_endpoints]
  }
  fleet {
    api_key  = var.elasticsearch_api_key
    endpoint = var.fleet_endpoint
  }
}

