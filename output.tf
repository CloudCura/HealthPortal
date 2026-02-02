output "public_landing_page" {
  description = "The URL of the CloudCura Health landing page"
  value       = azurerm_storage_account.static_web.primary_web_endpoint
}

output "bot_service_endpoint" {
  description = "Internal diagnostic endpoint for bot authentication testing"
  value       = "https://${local.target_bot_url}"
}