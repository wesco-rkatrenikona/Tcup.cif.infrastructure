## App Service Plan variables
variable "RsourceGroupName" {
  description = "The name of the resource group"
}

variable "RsourceGroupNameDev" {
  description = "The name of the resource group Dev"
}

variable "location" {
  description = "The Azure region in which all resources should be created"
}

# App Service
variable "AppServicePlanName" {
  description = "The name of the app service plan for the backend"
}

variable "AppServiceName" {
  description = "The name of the app service for the backend"
}

# Application Insights
variable "ApplicationInsightsName" {
  description = "The name of the application insights resource"
}

# Application Service Virtual Network Swift Connection
variable "AppServiceVirtualNetworkSwiftConnection" {
  description = "The Name of the Application Service Virtual Network Swift Connection Resource"
}

# Private DNS Zone
variable "PrivateDnsZone" {
  description = "The Name of the Private DNS Zone"
}

# Private  DNS Zone Virtual Network Link
variable "PrivateDnsZoneVirtualNetworkLink" {
  description = "The Name of the Private  DNS Zone Virtual Network Link"
}

# SQL Server
variable "SqlServer" {
  description = "The Name of the SQL Server"
}
variable "SqlServerVersion" {
  description = "The Name of the SQL Server version"
}
variable "SqlServerAdmin" {
  description = "The Name of the SQL Server Admin UserId"
}
variable "SqlServerAdminPassword" {
  description = "The Name of the SQL Server Admin Password"
}

# SQL Virtual Network Rule
variable "SqlVirtualNetworkRule" { 
  description = "The Name of the SQL Virtual Network Rule"
}

# Virtual Network
variable "VirtualNetworkName" { 
  description = "The Name of the Virtual Network Name"
}

# Subnet Plan
variable "SubnetPlan" { 
  description = "The Name of the Subnet Plan"
}

# Subnet Plan
variable "SubnetDatabase" { 
  description = "The Name of the Subnet Database"
}

