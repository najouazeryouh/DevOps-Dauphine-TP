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