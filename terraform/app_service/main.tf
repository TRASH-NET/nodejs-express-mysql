variable "location" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "client_secret" {}
variable "client_id" {}

terraform {
    required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>3.0"
    }
    
    tls = {
        source = "hashicorp/tls"
        version = "~>4.0"
        }
    }
}

provider "azurerm" {
    skip_provider_registration = "true"
    features {}
}

data "azurerm_resource_group" "rg" {
    name     = "ITUTB"
}

resource "azurerm_service_plan" "svp" {
    name                = "svp-ITUTB"
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    os_type             = "Linux"
    sku_name            = "F1"
}

resource "azurerm_linux_web_app" "app" {
    name                = "app-ITUTB"
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_service_plan.rg.location
    service_plan_id     = azurerm_service_plan.svp.id
    https_only = true
    enabled = true

    site_config {
        always_on = true
        minimum_tls_version = 1.2
        application_stack {
            node_version = "20-lts"
        }
    }
    app_settings = {
        "WEBSITE_NODE_DEFAULT_VERSION" = "20-lts"
    }
}

resource "azurerm_app_service_source_control" "src" {
    app_id   = azurerm_linux_web_app.app.id
    repo_url = "https://github.com/TRASH-NET/nodejs-express-mysql"
    branch   = "main"
    github_action_configuration {
        code_configuration {
            runtime_stack = "node"
            runtime_version = 20
        }
    }
}