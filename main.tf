locals {
  org_name    = "cloudcura"
  environment = "test"
  app_suffix  = "auth"

  bot_prefix     = "developers-bot"
  target_bot_url = "${local.bot_prefix}-${local.environment}-${local.app_suffix}"

  common_tags = {
    Owner            = "CloudCura-DevOps"
    Criticality      = "High"
    InternalEndpoint = local.target_bot_url 
    ManagedBy        = "Terraform"
  }
}

# 1. App Service Plan for the Bot
resource "azurerm_service_plan" "bot_plan" {
  name                = "${local.org_name}-bot-plan"
  resource_group_name = azurerm_resource_group.web_rg.name
  location            = azurerm_resource_group.web_rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# 2. The Chat Bot App Service: CB[Flag_2_TF_PLAN_AUDIT_STATE_0x22]
resource "azurerm_linux_web_app" "chat_bot" {
  name                = "${local.bot_prefix}-${local.environment}-${local.app_suffix}"
  resource_group_name = azurerm_resource_group.web_rg.name
  location            = azurerm_resource_group.web_rg.location
  service_plan_id     = azurerm_service_plan.bot_plan.id

  site_config {
    always_on = false
  }

  tags = local.common_tags
}

# 3. Static Web Storage (Landing Page)
resource "azurerm_storage_account" "static_web" {
  name                     = "${local.org_name}publicweb"
  resource_group_name      = azurerm_resource_group.web_rg.name
  location                 = azurerm_resource_group.web_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
  }

  tags = local.common_tags
}