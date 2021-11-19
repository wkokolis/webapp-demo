/* -------------------------------------------------------------------------
   STATE CONFIGURATION
   ------------------------------------------------------------------------- */
terraform {
  required_providers {
    aws = {
      source                    = "hashicorp/aws"
      version                   = "~> 3.65.0"
    }
    kubernetes = {
      source                    = "hashicorp/kubernetes"
      version                   = "~> 1.13.3"
    }
  }

  backend "s3" {
    bucket			= "kokolis-demo-state"
    region                      = "us-east-1"
  }
}


/* -------------------------------------------------------------------------
   PROVIDER SETUP
   ------------------------------------------------------------------------- */
provider "kubernetes" {}

provider "aws" {
  region                        = "us-east-1"
}
