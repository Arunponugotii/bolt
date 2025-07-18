terraform {
  backend "gcs" {
    bucket = "terraform-statefile-bucket-tf2"
    prefix = "terraform/state/gke-cluster"
  }
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  required_version = ">= 1.0"
}