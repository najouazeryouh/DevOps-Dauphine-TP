provider "google" {
  project     = "devops-tp3"
  region      = "us-central1"
}


resource "google_artifact_registry_repository" "my-repo-tp6" {
  location      = "us-central1"
  repository_id = "website-tools"
  description   = "devops-tp6"
  format        = "DOCKER"
}


resource "google_project_service" "api-cloudresourcemanager" {
  project = "devops-tp3"
  service = "cloudresourcemanager.googleapis.com" # Remplacez par le nom de l'API que vous souhaitez activer
}

resource "google_project_service" "api-serviceusage" {
  project = "devops-tp3"
  service = "serviceusage.googleapis.com" 
}


resource "google_project_service" "api-artifact-registry" {
  project = "devops-tp3"
  service = "artifactregistry.googleapis.com" 
}  

resource "google_project_service" "api-sqladmin" {
  project = "devops-tp3"
  service = "sqladmin.googleapis.com" 
}

resource "google_project_service" "api-cloudbuild" {
  project = "devops-tp3"
  service = "cloudbuild.googleapis.com" 
}

resource "google_sql_user" "wordpress" {
   name     = "wordpress"
   instance = "main-instance"
   password = "ilovedevops"
}


resource "google_sql_database" "sql-database" {
  name     = "wordpress"
  instance = "main-instance"
}

resource "google_project_service" "api-cloudrun" {
  project = "devops-tp3"
  service = "run.googleapis.com" 
}


resource "google_cloud_run_service" "default" {
name     = "serveur-wordpress"
location = "us-central1"

template {
   spec {
      containers {
      image = "us-central1-docker.pkg.dev/devops-tp3/website-tools/wordpressimg2"
      ports {
        container_port = 80
      }
      }      
   }

   metadata {
      annotations = {
            "run.googleapis.com/cloudsql-instances" = "devops-tp3:us-central1:main-instance"
      }
   }
}

traffic {
   percent         = 100
   latest_revision = true
}
}


data "google_iam_policy" "noauth" {
   binding {
      role = "roles/run.invoker"
      members = [
         "allUsers",
      ]
   }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
   location    = google_cloud_run_service.default.location
   project     = google_cloud_run_service.default.project
   service     = google_cloud_run_service.default.name

   policy_data = data.google_iam_policy.noauth.policy_data
}