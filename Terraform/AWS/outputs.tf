# Output para pegar o ID do grupo de segurança automático criado
output "eks_control_plane_sg" {
  value = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id
}

# Output para pegar o Endereco do tunel 1
output "aws_vpn_tunnel1_address" {
  value = aws_vpn_connection.vpn_connection.tunnel1_address
}

# Output para pegar o Endereco do tunel 2
output "aws_vpn_tunnel2_address" {
  value = aws_vpn_connection.vpn_connection.tunnel2_address
}

# Output para pegar a chave do tunel 1
output "tunnel1_preshared_key" {
  value = aws_vpn_connection.vpn_connection.tunnel1_preshared_key
}

# Output para pegar a chave do tunel 2
output "tunnel2_preshared_key" {
  value = aws_vpn_connection.vpn_connection.tunnel2_preshared_key
}