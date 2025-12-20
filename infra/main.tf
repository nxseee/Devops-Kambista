locals {
  apis = toset([
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "iam.googleapis.com",
    "sts.googleapis.com",
    "logging.googleapis.com",
  ])
}

resource "google_project_service" "apis" {
  for_each           = local.apis
  service            = each.value
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "docker" {
  depends_on    = [google_project_service.apis]
  location      = var.region
  repository_id = var.artifact_repo_id
  format        = "DOCKER"
}

resource "google_container_cluster" "gke" {
  depends_on = [google_project_service.apis]
  name       = var.cluster_name
  location   = var.region

  enable_autopilot    = true
  deletion_protection = false
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}
