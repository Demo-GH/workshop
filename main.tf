terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "workshop"
    storage_account_name = "ststorage1234125"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_service_plan" "example" {
  name                = "example-app-service-plan123123"
  location            = "westeurope"
  resource_group_name = "workshop"
  os_type             = "Linux"
  sku_name            = "P0v3"
}


resource "azurerm_linux_web_app" "example" {
  name                = "example-webapp-123123i95u8fhwfdsewdwsa123"
  location            = "westeurope"
  resource_group_name = "workshop"
  service_plan_id     = azurerm_service_plan.example.id
  site_config {}
}

resource "azurerm_storage_account" "example_storage" {
  name                     = "storagea23123234"
  resource_group_name      = "workshop"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "example" {
  name                   = "workshop-mysql-server"
  resource_group_name    = "workshop"
  location               = "westeurope"
  administrator_login    = "mysqladminuser"
  administrator_password = "P@ssw0rd1234!"
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"
  backup_retention_days  = 7
  geo_redundant_backup_enabled = false
  zone                   = "1"
  storage {
    size_gb = 32
  }
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "example" {
  name                = "workshopdb"
  resource_group_name = "workshop"
  server_name         = azurerm_mysql_flexible_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}