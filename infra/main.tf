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

resource "kubernetes_namespace_v1" "ns" {
  metadata {
    name = var.namespace
  }
}

locals {
  image_uri = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo_id}/${var.image_name}:${var.image_tag}"
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = "hello"
    namespace = kubernetes_namespace_v1.ns.metadata[0].name
    labels    = { app = "hello" }
  }

  spec {
    replicas = 2
    selector { match_labels = { app = "hello" } }

    template {
      metadata { labels = { app = "hello" } }

      spec {
        container {
          name              = "hello"
          image             = local.image_uri
          image_pull_policy = "Always"
          port { container_port = 8080 }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 8080
            }
            initial_delay_seconds = 10
            period_seconds        = 20
          }

          resources {
            requests = { cpu = "50m", memory = "64Mi" }
            limits   = { cpu = "250m", memory = "256Mi" }
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_non_root            = true
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "lb" {
  metadata {
    name      = "hello-lb"
    namespace = kubernetes_namespace_v1.ns.metadata[0].name
    labels    = { app = "hello" }
  }

  spec {
    selector = { app = "hello" }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

