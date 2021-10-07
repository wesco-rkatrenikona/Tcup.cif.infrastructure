
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.71.0"
	     }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

 subscription_id = "a47df434-bd9f-45e9-8f5c-4d2663462848"
   
   tenant_id       = "381d31b0-f4b9-4f22-a0dd-92488db3eb8"
   skip_provider_registration = true
}


# Preparing Multiple-Subnets creation
#AppService Subnet updating
data "azurerm_subnet" "snet-NP-shared-dev-plan-07" {
  name                 = var.SubnetPlan
  virtual_network_name = var.VirtualNetworkName
  resource_group_name  = var.RsourceGroupNameDev
  #address_prefixes     = ["10.0.1.0/24"]
  }

data "azurerm_subnet" "database" {
  name                 = var.SubnetDatabase
  virtual_network_name = var.VirtualNetworkName
  resource_group_name  = var.RsourceGroupNameDev
  #address_prefixes     = ["10.0.3.0/24"]
  #service_endpoints    = ["Microsoft.Sql"]
}





# create a Azure App service plan and prepare javawebapp and appinsights

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = var.AppServicePlanName
  location            = var.location
  resource_group_name = var.RsourceGroupName

  sku {
    tier = "Premiumv2"
    size = "P1v2"
  }
}
# creating App Insights
resource azurerm_application_insights app_insights {
  name                = var.ApplicationInsightsName
  resource_group_name = var.RsourceGroupName
  location            = var.location
  application_type    = "java"
  sampling_percentage = "100"
  retention_in_days   = "90"
  
  lifecycle {
    ignore_changes = [
      tags,
      application_type
    ]
  }
}

# creating Java webapp service
resource "azurerm_app_service" "frontwebapp" {
  name                = var.AppServiceName
  location            = var.location
  resource_group_name = var.RsourceGroupName
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  
  

  app_settings = {
    "WEBSITE_DNS_SERVER": "168.63.129.16",
    "WEBSITE_VNET_ROUTE_ALL": "1"
	"APPINSIGHTS_INSTRUMENTATIONKEY": azurerm_application_insights.app_insights.instrumentation_key
	"APP_ENV": "dev"
	"AZURE_TOMCAT9046_HOME": "C:/home/tomcat"
	"anypointmq_client_id": "a553dc251b47421aaa5e2db4aba05d49"
	"anypointmq_client_secret": "924Ab7d858874F4999F1c057C6aCD95E"
	"anypointmq_authURI": "https://mq-us-east-1.anypoint.mulesoft.com/api/v1/authorize"
	"anypointmq_brokerURI": "https://mq-us-east-1.anypoint.mulesoft.com/api/v1/organizations/"
  }
  connection_string {
    name  = "SQLServerDB"
    type  = "SQLServer"
    value = "jdbc:sqlserver://tcupcifsqlserver.database.windows.net:1433;database=np-cif-dev"
  }
  
  site_config {
  always_on=true
    java_version           = "1.8"
    java_container         = "tomcat"
    java_container_version = "9.0.46"
  }
  tags = {
    environment = "dev"
  }
}



#integrate our java webapp with subnet mask
resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
 app_service_id  = azurerm_app_service.frontwebapp.id
  subnet_id       = data.azurerm_subnet.snet-NP-shared-dev-plan-07.id
}


# create private dnszone
#resource "azurerm_private_dns_zone" "dnsprivatezone" {
 # name                = var.PrivateDnsZone
  #resource_group_name = var.RsourceGroupName
#}


#resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
 # name = var.PrivateDnsZoneVirtualNetworkLink
  #resource_group_name = var.RsourceGroupName
  #private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone.name
  #virtual_network_name = "vnet-NP-shared-dev"
 #}
 
 # Provision SQL server and integration with vnet Subnet
resource "azurerm_sql_server" "sqlserver" {
  name                         = var.SqlServer
  resource_group_name          = var.RsourceGroupName
  location                     = var.location
  version                      = var.SqlServerVersion
  administrator_login          = var.SqlServerAdmin
  administrator_login_password = var.SqlServerAdminPassword
}

resource "azurerm_sql_database" "sqldatabase" {
  name                = var.SQLDatabase
  resource_group_name = var.RsourceGroupName
  location            = var.location
  server_name         = azurerm_sql_server.sqlserver.name

  


  tags = {
    environment = "dev"
  }
}

#integrate our SQL Server with subnet mask
resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = var.SqlVirtualNetworkRule
  resource_group_name = var.RsourceGroupName
  server_name         = azurerm_sql_server.sqlserver.name
  subnet_id           = data.azurerm_subnet.database.id
}










