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


# MSSQL Server
resource "azurerm_mssql_server" "example" {
  name                         = "workshop-mssql-server123"
  resource_group_name          = "workshop"
  location                    = "polandcentral"
  version                     = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssw0rd1234!"
  minimum_tls_version          = "1.2"
}

# MSSQL Database
resource "azurerm_mssql_database" "example" {
  name               = "workshopdb123131"
  server_id          = azurerm_mssql_server.example.id
  sku_name           = "S0"
  collation          = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb        = 5
}

resource "azurerm_mssql_server" "example" {
  name                         = "example-sqlserver"
  resource_group_name          = "workshop"
  location                     = "polandcentral"
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "example" {
  name         = "example-db"
  server_id    = azurerm_mssql_server.example.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}