output "default_site_hostname" {
  description = "The Default Hostname associated with the App Service"
  value       = azurerm_app_service.data_augmentation_test_service_docker_app.default_site_hostname
}
