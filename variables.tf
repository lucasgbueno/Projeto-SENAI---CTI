#################### CONFIGURAÇÃO DO PROVIDER AWS ####################
# Região da AWS.
variable "region_aws" {
 description = "Região da AWS para os Recursos serem criados."
 type        = string
 default     = "us-east-1"
}

variable "subId" {
  sensitive = true
}