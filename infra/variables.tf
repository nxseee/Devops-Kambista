variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "cluster_name" {
  type    = string
  default = "kambista-gke"
}

variable "namespace" {
  type    = string
  default = "kambista-dev"
}

variable "artifact_repo_id" {
  type    = string
  default = "kambista-repo"
}
