# Criando o Cluster EKS
resource "aws_eks_cluster" "eks-cluster" {
  depends_on = [ var.eks_service_role_arn, aws_security_group.eks_sg, var.eks_cluster_name, aws_subnet.eks_public_subnet_a, aws_subnet.eks_public_subnet_b, aws_security_group.eks_sg ]
  name = var.eks_cluster_name
  role_arn = var.eks_service_role_arn
  vpc_config {
    subnet_ids = [aws_subnet.eks_public_subnet_a.id, aws_subnet.eks_public_subnet_b.id]
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

# Adicionando o complemento kube-proxy
resource "aws_eks_addon" "kube-proxy" {
  depends_on = [aws_eks_cluster.eks-cluster, aws_eks_node_group.ndg-1]
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "kube-proxy"
  addon_version = "v1.31.1-eksbuild.2"
}
# Adicionando o complemento CNI da Amazon VPC
resource "aws_eks_addon" "vpc-cni" {
    depends_on = [aws_eks_cluster.eks-cluster, aws_eks_node_group.ndg-1]
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "vpc-cni"
  addon_version = "v1.18.6-eksbuild.1"
}
# Adicionando o complemento Agente de Identidade de Pods do Amazon EKS
resource "aws_eks_addon" "pod-identity" {
  depends_on = [aws_eks_cluster.eks-cluster, aws_eks_node_group.ndg-1]
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "eks-pod-identity-agent"
  addon_version = "v1.3.2-eksbuild.2"
}
# Adicionando o complemento Driver do Amazon EBS CSI
resource "aws_eks_addon" "ebs-csi" {
  depends_on = [aws_eks_cluster.eks-cluster, aws_eks_node_group.ndg-1]
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "aws-ebs-csi-driver"
  addon_version = "v1.36.0-eksbuild.1"
}
# Adicionando o complemento coredns
resource "aws_eks_addon" "coredns" {
  depends_on = [aws_eks_cluster.eks-cluster, aws_eks_node_group.ndg-1]
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "coredns"
  addon_version = "v1.11.3-eksbuild.2"
  resolve_conflicts_on_create = "OVERWRITE"
}

# Criando os Node Groups
resource "aws_eks_node_group" "ndg-1" {
  depends_on = [ aws_eks_cluster.eks-cluster, var.eks_instance_role_arn, var.eks_nodes_name, var.eks_node_ami_type, var.eks_node_disk_size, var.eks_node_instance_type, var.eks_node_capacity_type, var.eks_max_unavailable, var.eks_node_desired_size, var.eks_node_max_size, var.eks_node_min_size, aws_subnet.eks_public_subnet_a, aws_subnet.eks_public_subnet_b ]
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = var.eks_nodes_name
  node_role_arn   = var.eks_instance_role_arn
  ami_type = var.eks_node_ami_type
  disk_size = var.eks_node_disk_size
  instance_types = var.eks_node_instance_type
  capacity_type = var.eks_node_capacity_type
  update_config {
    max_unavailable = var.eks_max_unavailable
  }
  scaling_config {
    desired_size = var.eks_node_desired_size
    max_size     = var.eks_node_max_size
    min_size     = var.eks_node_min_size
  }
  subnet_ids = [
    aws_subnet.eks_public_subnet_a.id,
    aws_subnet.eks_public_subnet_b.id,
  ]
}

# Modificar as regras do grupo de segurança automaticamente criado pelo EKS
resource "aws_security_group_rule" "allow_custom_ingress" {
  type              = "ingress"
  from_port         = 443  
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id  
  cidr_blocks       = ["0.0.0.0/0"]  
  description       = "Permitir trafego HTTPS para o plano de controle"
}
resource "aws_security_group_rule" "allow_custom_ingress_2" {
  type              = "ingress"
  from_port         = 80  
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id  
  cidr_blocks       = ["0.0.0.0/0"] 
  description       = "Permitir trafego HTTP para o plano de controle"
}
resource "aws_security_group_rule" "allow_custom_ingress_3" {
  type              = "ingress"
  from_port         = 30880  
  to_port           = 30880
  protocol          = "tcp"
  security_group_id = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id  
  cidr_blocks       = ["0.0.0.0/0"]  
  description       = "Permitir trafego da porta do KubeSphere para o plano de controle"
}