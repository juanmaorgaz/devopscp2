provider "azurerm" { 
  features {} 
  subscription_id = "<SUBSCRIPTION_ID>" 
  client_id = "<APP_ID>"            # se obtiene al crear el service principal 
  client_secret = "<CLIENT_SECRET>" # se obtiene al crear el service principal 
  tenant_id = "<TENANT_ID>"         # se obtiene al crear el service principal 
}
