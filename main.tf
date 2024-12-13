module "vpn_azure" {
  source = "./Terraform/AZURE"
  tunnel1_address_aws = module.vpn_aws.aws_vpn_tunnel1_address
  tunnel2_address_aws = module.vpn_aws.aws_vpn_tunnel2_address
  tunnel1_preshared_key_aws = module.vpn_aws.tunnel1_preshared_key
  tunnel2_preshared_key_aws = module.vpn_aws.tunnel2_preshared_key
  depends_on = [ module.vpn_aws.tunnel1_address_aws, module.vpn_aws.tunnel2_address_aws, module.vpn_aws.tunnel1_preshared_key_aws, module.vpn_aws.tunnel2_preshared_key_aws ]
}

module "vpn_aws" {
  source = "./Terraform/AWS"
  vpn_gateway_ip_address_azure = module.vpn_azure.azure_vpn_gateway_ip_address
  aws_region = var.region_aws
  eks_service_role_arn = var.eks_service_role_arn
  eks_instance_role_arn = var.eks_instance_role_arn
  depends_on = [ module.vpn_azure.vpn_gateway_ip_address_azure, var.eks_service_role_arn, var.eks_instance_role_arn  ]
}