//region Custom roles

resource "google_project_iam_custom_role" "wiz_security_role_disk_analysis_ext" {
  role_id = var.wiz_security_role_disk_analysis_ext_name
  project = var.project_id
  title   = var.wiz_security_role_disk_analysis_ext_name
  permissions = [
    "compute.globalOperations.get",
    "compute.disks.useReadOnly",
    "compute.disks.get",
    "compute.images.list",
    "compute.images.useReadOnly",
    "compute.images.get",
    "compute.images.getIamPolicy",
    "compute.images.setIamPolicy",
    "compute.snapshots.list",
    "compute.snapshots.get"
  ]
  depends_on = [time_sleep.required_apis]
}

//endregion Custom roles

resource "google_project_iam_member" "disk_analysis_roles" {
  for_each = local.disk_analysis_roles
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${local.disk_analysis_service_account_id}"
}

resource "google_project_iam_member" "wiz_da_role" {
  project    = var.project_id
  role       = google_project_iam_custom_role.wiz_security_role_disk_analysis_ext.name
  member     = "serviceAccount:${local.disk_analysis_service_account_id}"
  depends_on = [google_project_iam_custom_role.wiz_security_role_disk_analysis_ext]
}
