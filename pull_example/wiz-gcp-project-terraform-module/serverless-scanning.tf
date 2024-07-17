resource "google_project_iam_custom_role" "wiz_security_role_serverless_scanning_ext" {
  count   = var.serverless_scanning ? 1 : 0
  project = var.project_id
  role_id = var.wiz_security_role_serverless_scanning_ext_name
  title   = var.wiz_security_role_serverless_scanning_ext_name
  permissions = [
    "artifactregistry.repositories.get",
    "artifactregistry.repositories.downloadArtifacts",
    "cloudfunctions.functions.get",
    "cloudfunctions.functions.sourceCodeGet",
    "run.revisions.get",
    "storage.objects.get",
    "storage.objects.list"
  ]
}

resource "google_project_iam_member" "wiz_worker_security_role_serverless_scanning_ext" {
  count      = var.serverless_scanning ? 1 : 0
  project    = var.project_id
  role       = google_project_iam_custom_role.wiz_security_role_serverless_scanning_ext[0].name
  member     = "serviceAccount:${local.disk_analysis_service_account_id}"
  depends_on = [google_project_iam_custom_role.wiz_security_role_serverless_scanning_ext]
}
