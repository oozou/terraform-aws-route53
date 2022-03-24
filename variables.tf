/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "tags" {
  description = "Tags to add more; default tags contian {terraform=true, environment=var.environment}"
  type        = map(string)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                                 Hostxedzone                                */
/* -------------------------------------------------------------------------- */
variable "is_create_zone" {
  description = "Wherther to create a zone or not"
  type        = bool
  default     = true
}

variable "is_public_zone" {
  description = "Wherther to create a zone or not"
  type        = bool
  default     = true
}

variable "dns_name" {
  description = "(Required) This is the name of the hosted zone."
  type        = string
}

variable "vpc_id" {
  description = "Required when hostzone is private, to associate with VPC"
  type        = string
  default     = ""
}

/* -------------------------------------------------------------------------- */
/*                                   Route53                                  */
/* -------------------------------------------------------------------------- */
variable "dns_records" {
  description = "Map of DNS records"
  type        = any
  default     = {}
}
