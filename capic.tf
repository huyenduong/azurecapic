terraform {
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = ">3.1.0"
    }
  }
}

# Provider in subs huyeduon-Demo04
provider "azure" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {
    template_deployment {
      delete_nested_items_during_deletion = false
    }
  }
}

# Deploy a resource group
resource "azurerm_resource_group" "capic2502" {
  name     = var.rgName
  location = var.location
}

# Deploy cAPIC from ARM template
resource "azurerm_resource_group_template_deployment" "capic" {
  name                = var.deployName
  resource_group_name = azurerm_resource_group.capic2502.name
  deployment_mode     = "Incremental"
  template_content    = file("template.json")
  parameters_content = jsonencode({
    location                 = { value = var.location }
    _artifactsLocation       = { value = "https://catalogartifact.azureedge.net/publicartifacts/cisco.cisco-aci-cloud-apic-8daf35dd-b9ee-4fd4-9235-74bc41ddc901-25_0_2-byol/Artifacts/mainTemplate.json" }
    adminPasswordOrKey       = { value = "123Cisco123!" }
    adminPublicKey           = { value = "ssh-rsa AAAAB3NzA6CI26ym4VD1PWBq83rx3z1qPQyL80ovesUxfxA8lp9DgjNdiUSyys2Mt2NVzT7J9vGKpnIK3FxrMW7RkDXBb6N8NCbyvu5d+QVFsbjej5neOAfSR7YJSDLhy2bUrZqKVefOkUeHiufo+hPqObMCYjc5GULV+cqTUTW2ippHtCKXTyYJudiJAaWFiWYcNiupH91LRvOABIQk38CX3OlnvG3ab+mUJq6XGMEKPJMlxI+cQBkjn2oKa8I8s43vyfsp6xwFjL" }
    location                 = { value = "eastus" }
    vmName                   = { value = "CloudAPIC" }
    vmSize                   = { value = "Standard_D8s_v3" }
    imageSku                 = { value = "25_0_2-byol" }
    imageVersion             = { value = "latest" }
    adminUsername            = { value = "capicuser" }
    fabricName               = { value = "ACI-Cloud-Fabric" }
    infraVNETPool            = { value = "10.50.0.0/24" }
    externalSubnets          = { value = "0.0.0.0/0" }
    publicIpDns              = { value = "cloudapic-f8749d40cd" }
    publicIPName             = { value = "CloudAPIC-pip" }
    publicIPSku              = { value = "Standard" }
    publicIPAllocationMethod = { value = "Static" }
    publicIPNewOrExisting    = { value = "new" }
    publicIPResourceGroup    = { value = "capic2502" }
    virtualNetworkName       = { value = "overlay-1" }
    mgmtNsgName              = { value = "controllers_cloudapp-cloud-infra" }
    mgmtAsgName              = { value = "controllers_cloudapp-cloud-infra" }
    subnetPrefix             = { value = "subnet-" }
  })
}

# Azure subscription
data "azurerm_subscription" "primary" {
}

data "azurerm_virtual_machine" "capic" {
  name = "CloudAPIC"
  resource_group_name = var.rgName
}

# Assign contributor role
resource "azurerm_role_assignment" "capic" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_virtual_machine.capic.identity.0.principal_id
}