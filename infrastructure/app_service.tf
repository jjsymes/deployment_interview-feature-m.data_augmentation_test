resource "azurerm_resource_group" "data_augmentation_test_group" {
  name     = "data-augmentation-test"
  location = "uksouth"
}

resource "azurerm_app_service_plan" "data_augmentation_test_app_service_plan" {
  name                = "${azurerm_resource_group.data_augmentation_test_group.name}-plan"
  location            = azurerm_resource_group.data_augmentation_test_group.location
  resource_group_name = azurerm_resource_group.data_augmentation_test_group.name
  kind = "Linux"
  sku {
    tier = "Standard"
    size = "B1"
  }
  reserved = true
}

resource "azurerm_app_service" "data_augmentation_test_service_docker_app" {
  name                = "${azurerm_resource_group.data_augmentation_test_group.name}-dockerapp"
  location            = azurerm_resource_group.data_augmentation_test_group.location
  resource_group_name = azurerm_resource_group.data_augmentation_test_group.name
  app_service_plan_id = azurerm_app_service_plan.data_augmentation_test_app_service_plan.id

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_REGISTRY_SERVER_URL      = "https://index.docker.io"
  }

  site_config {
    linux_fx_version = "DOCKER|jjsymes/data_augmentation_test:latest"
    always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}
