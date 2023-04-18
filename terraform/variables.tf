variable "client_folder" {
  type        = string
  description = "The folder which is used to build the client image from."
}

variable "server_folder" {
  type        = string
  description = "The folder which is used to build the server image from."
}

variable "subscription_id" {
  type        = string
  description = "The azure subscription id to use."
}

variable "resource_group" {
  type        = string
  description = "The name of the resource group."
}

variable "registry_name" {
  type        = string
  description = "The name of the container registry."
}

variable "client_app_name" {
  type        = string
  description = "The name of the client app service."
}

variable "server_app_name" {
  type        = string
  description = "The name of the server app service."
}

variable "location" {
  type        = string
  description = "The location of the resource group."
}

variable "sku" {
  type        = string
  description = "The SKU of the web app service plan."
}

variable "service_plan_name" {
  type        = string
  description = "The name of the service plan."
}

variable "service_plan_sku" {
  type        = string
  description = "sku_name for service plan (https://azure.microsoft.com/en-gb/pricing/details/app-service/windows/)"
}

variable "os_type" {
  type        = string
  description = "OS to host the app service plan. Valid values are Windows or Linux."
  validation {
    condition     = var.os_type == "Linux" || var.os_type == "Windows"
    error_message = "os_type must be either Linux or Windows"
  }
}