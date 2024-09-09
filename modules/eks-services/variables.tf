variable "k8s_ca_certificate" {
  type        = string
  description = "The Kubernetes CA certificate"
}

variable "k8s_endpoint" {
  type        = string
  description = "The Kubernetes host endpoint"
}

variable "k8s_token" {
  type        = string
  description = "The Kubernetes access token"
}

variable "resource_prefix" {
  type        = string
  description = "The prefix to use for resource names."
  default     = "quinn-shift-left"
}

variable "wiz_service_account_name" {
  type    = string
  default = "wiz-kube-connector"
}

variable "wiz_namespace" {
  type    = string
  default = "wiz"
}

variable "wiz_admission_controller_mode" {
  type    = string
  default = "AUDIT"
  validation {
    condition     = contains(["AUDIT", "BLOCK"], var.wiz_admission_controller_mode)
    error_message = "Enforcement mode must either be 'AUDIT' or 'BLOCK'"
  }
}

variable "wiz_admission_controller_policies" {
  type    = list(string)
  default = []
}

variable "wiz_image_trust_policies" {
  type = list(string)
  default = []
}

variable "wiz_k8s_integration_client_id" {
  type    = string
  default = ""
}

variable "wiz_k8s_integration_client_secret" {
  type    = string
  default = ""
}

variable "wiz_sensor_pull_username" {
  type    = string
  default = ""
}

variable "wiz_sensor_pull_password" {
  type    = string
  default = ""
}

variable "use_wiz_admission_controller" {
  type    = bool
  default = false
}

variable "use_wiz_image_trust" {
  type    = bool
  default = false
  validation {
    condition     = !(var.use_wiz_image_trust && !local.wiz_image_trust_allowed)
    error_message = "use_wiz_image_trust can only be true if use_wiz_admission_controller is set to true."
  }
}

variable "use_wiz_k8s_audit_logs" {
  type    = bool
  default = false
}

variable "use_wiz_sensor" {
  type    = bool
  default = false
}
