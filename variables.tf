variable "region_name" {
  description = "The Azure region to deploy into."
}

variable "region_code" {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
}

variable "organization_name" {
  description = "The name of the organization that owns all AWS resources."
}

variable "department_name" {
  description = "The name of the department that owns all AWS resources."
}

variable "project_name" {
  description = "The name of the project that owns all AWS resources."
}

variable "stage" {
  description = "The name of the current environment stage."
}

variable resource_group_name {
  description = "The name of the resource group supposed to own all allocated resources; will create a new resource group if not specified"
  default = ""
}

variable resource_group_location {
  description = "The location of the resource group supposed to own all allocated resources"
  default = ""
}

variable network_name {
  description = "name of the reference network to create"
}

variable network_cidr {
  description = "CIDR block of the network"
}

variable network_security_groups_enabled {
  description = "Controls if default network security groups should be created and attached to all subnets"
  type = bool
  default = true
}

variable bastions_enabled {
  description = "Controls if the Bastion services should be instantiated"
  type = bool
  default = true
}