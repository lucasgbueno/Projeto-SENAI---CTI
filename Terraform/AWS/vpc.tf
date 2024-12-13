# Criando VPC na AWS.
resource "aws_vpc" "eks_vpc" {
  depends_on = [ var.vpc_cidr ]
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Criando Internet Gateway.
resource "aws_internet_gateway" "eks_igw" {
  depends_on = [ aws_vpc.eks_vpc ]
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = var.vpc_igw_name
  }
}

# Criando Tabela de Rota Pública.
resource "aws_route_table" "eks_public_route_table" {
  depends_on = [ aws_vpc.eks_vpc, aws_internet_gateway.eks_igw, var.vpc_cidr_public_route, var.vnet_cidr_subnet_public_a_vpn_azure, aws_vpn_gateway.vpn_gateway, var.vnet_cidr_subnet_public_b_vpn_azure ]
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = var.vpc_cidr_public_route
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  route {
    cidr_block = var.vnet_cidr_subnet_public_a_vpn_azure
    gateway_id = aws_vpn_gateway.vpn_gateway.id
  }
  route {
    cidr_block = var.vnet_cidr_subnet_public_b_vpn_azure
    gateway_id = aws_vpn_gateway.vpn_gateway.id
  }
  tags = {
    Name = var.vpc_public_route_table_name
  }
}

# Criando SubNet Pública A.
resource "aws_subnet" "eks_public_subnet_a" {
  depends_on = [ aws_vpc.eks_vpc, var.vpc_cidr_subnet_public_a ]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.vpc_cidr_subnet_public_a
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = var.vpc_subnet_public_a_name
  }
}

# Criando SubNet Pública B.
resource "aws_subnet" "eks_public_subnet_b" {
  depends_on = [ aws_vpc.eks_vpc, var.vpc_cidr_subnet_public_b ]
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.vpc_cidr_subnet_public_b
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = var.vpc_subnet_public_b_name
  }
}

# Associando Subnets Públicas à Tabela de Rotas Publica.
resource "aws_route_table_association" "eks_public_a" {
  depends_on = [ aws_subnet.eks_public_subnet_a, aws_route_table.eks_public_route_table ]
  subnet_id      = aws_subnet.eks_public_subnet_a.id
  route_table_id = aws_route_table.eks_public_route_table.id
}
# Associando Subnets Públicas à Tabela de Rotas Publica.
resource "aws_route_table_association" "eks_public_b" {
  depends_on = [ aws_subnet.eks_public_subnet_b, aws_route_table.eks_public_route_table ]
  subnet_id      = aws_subnet.eks_public_subnet_b.id
  route_table_id = aws_route_table.eks_public_route_table.id
}

# Criando Security Group para o EKS.
resource "aws_security_group" "eks_sg" {
  depends_on = [ aws_vpc.eks_vpc, var.vpc_security_group_name ]
  vpc_id = aws_vpc.eks_vpc.id
  name   = var.vpc_security_group_name

  ingress {
    description = "Permitir trafego HTTPS para o EKS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Permitir trafego HTTP para o EKS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Permitir trafego 8080 para o EKS"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Permitir trafego do KubeSphere para o EKS"
    from_port   = 30880
    to_port     = 30880
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.vnet_cidr_vpn_azure
  }

  tags = {
    Name = var.vpc_security_group_name
  }
}