terraform {
  required_version = ">= 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.19.0"
    }
  }
}

provider "google" {
  project = "erickfcs-default"
  region  = "us-central1"
  zone    = "us-central1-a"
}
