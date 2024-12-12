terraform {
  required_version = ">=1.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# Provider da AWS
provider "aws" {
  region = var.region_aws
  default_tags {
    tags = {
      "Environment" = "Production"
      "Project" = "CloudTurbo"
      "ManagedBy" = "Terraform"
      "Region" = "us-east-1"
      "Automated" = "True"
    }
  }
}

# Provider da AZURE
provider "azurerm" {
  features {}
  subscription_id = var.subId
}