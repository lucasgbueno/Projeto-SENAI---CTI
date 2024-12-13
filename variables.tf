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

# ID de serviço para criação do cluster EKS.
variable "eks_service_role_arn" {
  type = string
}

# ID de serviço para criação dos Nodes do EKS.
variable "eks_instance_role_arn" {
  type = string
}