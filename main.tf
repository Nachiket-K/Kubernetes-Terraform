terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.15.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
provider "google" {
  project="nachiket-devops"
  region="us-central1"
  zone = "us-central1-a"
}

data "kubectl_file_documents" "docs" {
    content = file("kubernetes-manifests.yaml")
}
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 5
  
}

resource "kubectl_manifest" "test" {
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value
}
