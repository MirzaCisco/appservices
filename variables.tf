variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

variable "client_id" {
  description = "The Azure Service Principal client ID."
  type        = string
}

variable "client_secret" {
  description = "The Azure Service Principal client secret."
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The Azure tenant ID."
  type        = string
}
