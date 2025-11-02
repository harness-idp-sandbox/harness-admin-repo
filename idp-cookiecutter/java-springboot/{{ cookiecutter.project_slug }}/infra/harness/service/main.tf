terraform {
  required_providers {
    harness = {
      source  = "harness/harness"
      version = ">= 0.33.0"
    }
  }
}

provider "harness" {
  # Reads from env:
  # HARNESS_ACCOUNT_ID, HARNESS_ORG_ID, HARNESS_PROJECT_ID (optional),
  # HARNESS_PLATFORM_API_KEY
  endpoint = "https://app.harness.io/gateway"
}

resource "harness_platform_service" "svc" {
  org_id     = var.org_id
  project_id = var.project_id
  identifier = var.service_id
  name       = var.service_name
  description = var.description

  yaml = <<-YAML
    service:
      name: ${var.service_name}
      identifier: ${var.service_id}
      orgIdentifier: ${var.org_id}
      projectIdentifier: ${var.project_id}
      serviceDefinition:
        type: Kubernetes
        spec:
          artifacts:
            primary:
              type: DockerRegistry
              spec:
                connectorRef: ${var.docker_connector_ref}
                imagePath: ${var.image_repo}
                tag: ${var.image_tag}
      gitOpsEnabled: false
  YAML
}
