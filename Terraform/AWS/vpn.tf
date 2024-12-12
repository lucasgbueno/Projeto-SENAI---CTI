resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "aws_vpn_gateway"
  }
}

resource "aws_customer_gateway" "cg" {
  bgp_asn    = 65000
  ip_address = var.vpn_gateway_ip_address_azure
  type       = "ipsec.1"
  tags = {
    Name = "aws_azure_vpn_cg"
  }
}

resource "aws_vpn_connection" "vpn_connection" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.cg.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "aws_azure_ipsec_vpn"
  }
}

resource "aws_vpn_gateway_route_propagation" "vpn_propagation" {
  depends_on     = [aws_vpn_gateway.vpn_gateway, aws_route_table.eks_public_route_table]
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = aws_route_table.eks_public_route_table.id
}

resource "aws_vpn_connection_route" "vpn_static_route_1" {
  vpn_connection_id   = aws_vpn_connection.vpn_connection.id
  destination_cidr_block = var.vnet_cidr_subnet_public_a_vpn_azure
}
resource "aws_vpn_connection_route" "vpn_static_route_2" {
  vpn_connection_id   = aws_vpn_connection.vpn_connection.id
  destination_cidr_block = var.vnet_cidr_subnet_public_b_vpn_azure
}