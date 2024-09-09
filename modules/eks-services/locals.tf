locals {
  kubernetes_connector_name = "${var.resource_prefix}-connector-${random_id.uniq.hex}"
  wiz_image_trust_allowed = var.use_wiz_admission_controller
}
