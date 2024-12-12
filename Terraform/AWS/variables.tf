#################### CONFIGURAÇÃO DO PROVIDER ####################
# Região da AWS.
variable "aws_region" {}

#################### CONFIGURAÇÕES DA VPC ####################

# Nome da VPC.
variable "vpc_name" {
  description = "Nome da vpc."
  type        = string
  default     = "eks-vpc"
}
# CIDR da VPC.
variable "vpc_cidr" {
  description = "CIDR da vpc."
  type        = string
  default     = "172.16.0.0/16"
}
# Nome do Internet Gateway.
variable "vpc_igw_name" {
  description = "Nome do Internet Gateway."
  type        = string
  default     = "eks-igw"
}

#################### CONFIGURAÇÃO DAS ROTAS ####################

# Nome da Tabela de Rota Pública.
variable "vpc_public_route_table_name" {
  description = "Nome da Tabela de Rota Pública."
  type        = string
  default     = "eks-public-route-table"
}
# Caminho da rota publica da VPC.
variable "vpc_cidr_public_route" {
  description = "CIDR da rota Pública da vpc."
  type        = string
  default     = "0.0.0.0/0"
}
# Nome da Tabela de Rota Privada.
variable "vpc_private_route_table_name" {
  description = "Nome da Tabela de Rota Privada."
  type        = string
  default     = "eks-private-route-table"
}

#################### CONFIGURAÇÃO DA VPN ####################

# CIDR da VNET.
variable "vnet_cidr_vpn_azure" {
  description = "CIDR da VNET."
  type        = list(string)
  default     = ["172.32.0.0/16"]
}

# CIDR da SubNet Publica A da VNET para VPN AZURE.
variable "vnet_cidr_subnet_public_a_vpn_azure" {
  description = "CIDR da SubNet Publica A da VNET para VPN AZURE."
  type        = string
  default     = "172.32.0.0/24"
}

# CIDR da SubNet Publica B da VNET para VPN AZURE.
variable "vnet_cidr_subnet_public_b_vpn_azure" {
  description = "CIDR da SubNet Publica B da VNET para VPN AZURE."
  type        = string
  default     = "172.32.1.0/24"
}

# IP do Gateway de vpn azure para aws
variable "vpn_gateway_ip_address_azure" {
  description = "IP do Gateway de vpn azure para aws."
  type        = string
}

#################### CONFIGURAÇÃO DAS SUBREDES PUBLICAS ####################

# Nome da SubNet Publica A da VPC.
variable "vpc_subnet_public_a_name" {
  description = "Nome da SubNet Publica A da VPC."
  type        = string
  default     = "EKS-Public-SubNet-A"
}
# CIDR da SubNet Publica A da VPC.
variable "vpc_cidr_subnet_public_a" {
  description = "CIDR da SubNet Publica A da VPC."
  type        = string
  default     = "172.16.0.0/24"
}
# Nome da SubNet Publica B da VPC.
variable "vpc_subnet_public_b_name" {
  description = "Nome da SubNet Publica B da VPC."
  type        = string
  default     = "EKS-Public-SubNet-B"
}
# CIDR da SubNet Publica B da VPC.
variable "vpc_cidr_subnet_public_b" {
  description = "CIDR da SubNet Publica B da VPC."
  type        = string
  default     = "172.16.1.0/24"
}

#################### CONFIGURAÇÃO DO GRUPO DE SEGURANÇA

# Nome do Security Group do EKS.
variable "vpc_security_group_name" {
  description = "Nome do Security Group do EKS."
  type        = string
  default     = "eks-cluster-sg"
}

#################### CONFIGURACAO DO EKS ####################

# Nome do Cluster EKS.
variable "eks_cluster_name" {
  description = "Nome do Cluster do K8S na AWS"
  type = string #lista,number,bool
  default = "eks-tf-cti"
}
# ID de serviço para criação do cluster EKS.
variable "eks_service_role_arn" {
  type = string
}

#################### CONFIGURACAO DOS NODES

# Nome dos Nodes.
variable "eks_nodes_name" {
  description = "Nome dos Nodes"
  type = string
  default = "tf-ndg-1"
}
# ID de serviço para criação dos Nodes do EKS.
variable "eks_instance_role_arn" {
  type = string
}
# Codigo do tipo de AMI dos Nodes.
variable "eks_node_ami_type" {
  description = "Codigo do tipo de AMI para usar nos Nodes"
  type = string
  default = "AL2_x86_64"
}
# Tamanho dos discos dos Nodes.
variable "eks_node_disk_size" {
  description = "Tamanho do disco dos Nodes"
  type = string
  default = "40"
}
# Tipo de instancia dos Nodes.
variable "eks_node_instance_type" {
  description = "Tipo de instancia dos Nodes"
  type = list(string)
  #default = ["t3.medium"]
  default = ["t3.large"]
}
# Capacidade da Instancia.
variable "eks_node_capacity_type" {
  description = "Tipo de instancia (ON_DEMAND/SPOT)"
  type = string
  default = "ON_DEMAND"
}
# Maximo de nos indisponiveis na atualização de versão dos Nodes.
variable "eks_max_unavailable" {
  description = "Número máximo de nós indisponíveis durante a atualização da versão do grupo de nós."
  type = number
  default = 2
}
# Quantidade desejada de Nodes.
variable "eks_node_desired_size" {
  description = "Quantidade Desejada de Nodes no EKS."
  type = number
  default = 3
}
# Quantidade Maxima de Nodes.
variable "eks_node_max_size" {
  description = "Quantidade Maxima de Nodes no EKS."
  type = number
  default = 4
}
# Quantidade Minima de Nodes.
variable "eks_node_min_size" {
  description = "Quantidade Minima de Nodes no EKS."
  type = number
  default = 1
}