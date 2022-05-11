terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.15.0"
    }
  }
}
provider "google" {
  project="nachiket-devops"
  region="us-central1"
  zone = "us-central1-a"
}

resource "google_container_cluster" "primary"{
  name     = "new-gke-cluster"
  location = "us-central1"
  initial_node_count = 1
  remove_default_node_pool = true
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
 cluster    = google_container_cluster.primary.name
  node_count =1
  
}