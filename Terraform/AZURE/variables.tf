#################### CONFIGURACAO DO GRUPO DE RECURSOS

# Nome do Resource Group.
variable "resource_group_name" {
  description = "Nome do Resource Group."
  type        = string
  default     = "RG-AKS-CTI"
}
# Local de criação do Resource Group.
variable "resource_group_location" {
  description = "Local de criação do Resource Group."
  type        = string
  default     = "East US"
}

#################### CONFIGURACAO DA VNET

# Nome da VNET.
variable "vnet_name" {
  description = "Nome da VNET."
  type        = string
  default     = "VNET-AKS-CTI"
}
# CIDR da VNET.
variable "vnet_cidr" {
  description = "CIDR da VNET."
  type        = list(string)
  default     = ["172.32.0.0/16"]
}
# CIDR da VNET. (String)
variable "vnet_cidr_string" {
  description = "CIDR da VNET."
  type        = string
  default     = "172.32.0.0/16"
}
# Local de criação da VNET.
variable "vnet_location" {
  description = "Local onde a VNET sera criada."
  type        = string
  default     = "East US"
}

#################### CONFIGURACAO DAS SUBREDES

# Nome da SubNet Publica A da VNET.
variable "vnet_subnet_public_a_name" {
  description = "Nome da SubNet Publica A da VNET."
  type        = string
  default     = "AKS-Public-SubNet-A"
}
# CIDR da SubNet Publica A da VNET.
variable "vnet_cidr_subnet_public_a" {
  description = "CIDR da SubNet Publica A da VNET."
  type        = list(string)
  default     = ["172.32.0.0/24"]
}
# Nome da SubNet Publica B da VNET.
variable "vnet_subnet_public_b_name" {
  description = "Nome da SubNet Publica B da VNET."
  type        = string
  default     = "AKS-Public-SubNet-B"
}
# CIDR da SubNet Publica B da VNET.
variable "vnet_cidr_subnet_public_b" {
  description = "CIDR da SubNet Publica B da VNET."
  type        = list(string)
  default     = ["172.32.1.0/24"]
}

#################### CONFIGURACAO DA VPN

# CIDR da SubNet da VPN.
variable "vnet_cidr_subnet_gateway_vpn" {
  description = "CIDR da SubNet da VPN."
  type        = list(string)
  default     = ["172.32.2.0/24"]
}

# CIDR da VPC para VPN AWS.
variable "vpc_aws_cidr_vpn" {
  description = "CIDR da vpc da AWS."
  type        = string
  default     = "172.16.0.0/16"
}

# CIDR da SubNet Publica A da VPC para VPN AWS.
variable "vpc_cidr_subnet_public_a_vpn" {
  description = "CIDR da SubNet Publica A da VPC."
  type        = string
  default     = "172.16.0.0/24"
}

# CIDR da SubNet Publica B da VPC para VPN AWS.
variable "vpc_cidr_subnet_public_b_vpn" {
  description = "CIDR da SubNet Publica B da VPC."
  type        = string
  default     = "172.16.1.0/24"
}

# Endereço do tunel 1 aws para azure
variable "tunnel1_address_aws" {
  description = "Endereço do tunel 1 aws para azure."
  type        = string
}

# Endereço do tunel 2 aws para azure
variable "tunnel2_address_aws" {
  description = "Endereço do tunel 2 aws para azure."
  type        = string
}

# Chave do tunel 1 aws para azure
variable "tunnel1_preshared_key_aws" {
  description = "Chave do tunel 1 aws para azure."
  type        = string
}

# Chave do tunel 2 aws para azure
variable "tunnel2_preshared_key_aws" {
  description = "Chave do tunel 2 aws para azure."
  type        = string
}

#################### CONFIGURACAO DOS GRUPO DE SEGURANÇA 

# Nome do Security Group do AKS.
variable "vnet_security_group_name" {
  description = "Nome do Security Group do AKS."
  type        = string
  default     = "aks-cluster-sg"
}

#################### CONFIGURACAO DOS AKS

# Nome do Cluster AKS.
variable "aks_cluster_name" {
  description = "Nome do Cluster do K8S na AZURE."
  type = string #lista,number,bool
  default = "aks-tf-cti"
}
# Versão do K8S do Cluster AKS.
variable "aks_version" {
  description = "Versao do K8S do Cluster AKS na AZURE."
  type = string #lista,number,bool
  default = "1.31.1"
}
# DNS do cluster AKS.
variable "aks_cluster_dns" {
  description = "DNS do cluster AKS."
  type = string #lista,number,bool
  default = "dns"
}



#################### CONFIGURACAO DOS NODES

# Maximo de nos indisponiveis na atualização de versão dos Nodes.
variable "aks_node_min_size" {
  description = "Quantidade Minima de Nodes no EKS."
  type = number
  default = 2
}
# Quantidade Maxima de Nodes.
variable "aks_node_max_size" {
  description = "Quantidade Maxima de Nodes no AKS."
  type = number
  default = 3
}
# Quantidade desejada de Nodes.
variable "aks_node_desired_size" {
  description = "Quantidade Desejada de Nodes no AKS."
  type = number
  default = 2
}
# Quantidade Maxima de póds por Nodes.
variable "aks_pods_max_size" {
  description = "Quantidade Maxima de Pod por Nodes no AKS."
  type = number
  default = 110
}