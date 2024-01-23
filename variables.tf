variable "argocd_application_name" {
  type        = string
  description = "A string representing the ArgoCD application name. (Required if `deploy_argocd_application` is `true`)"
  default     = ""
}

variable "argocd_application_namespace" {
  type        = string
  description = "A string representing the kubernetes namespace in which to deploy the defined application. (Required if `deploy_argocd_application` is `true`)"
  default     = ""
}

variable "argocd_destroy_wait" {
  type        = string
  description = "A string represeting the time to wait after destroying ArgoCD applications before cluster teardown should occur."
  default     = "60s"
}

variable "deploy_argocd_application" {
  type        = bool
  description = "A boolean representing whether the module should automatically deploy an ArgoCD application."
  default     = true
}

variable "eks_cluster_version" {
  type        = string
  description = "A string representing the desired kubernetes version for the EKS cluster."
  default     = "1.29"
}

variable "git_repo_url" {
  type        = string
  description = "A string representing the URL for the Git repository to use for deploying the desired application. (Required if `deploy_argocd_application` is `true`)"
  default     = ""
}

variable "git_repo_manifest_path" {
  type        = string
  description = "A string representing the path within the Git repository where kubernetes manifests for the desired application are stored. (Required if `deploy_argocd_application` is `true`)"
  default     = ""
}

variable "mapped_roles" {
  description = "A list of objects representing additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "mappped_users" {
  description = "A list of objects representing additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "resource_prefix" {
  type        = string
  description = "A string representing the prefix to use for resource names."
  default     = "wiz-shift-left"
}

variable "region" {
  type        = string
  description = "A string representing the name of the AWS region to use."
  default     = "us-east-1"
}

variable "wiz_admission_controller_mode" {
  type        = string
  description = "A string representing the mode in which the Wiz Admission Controller should operate."
  default     = "AUDIT"

  validation {
    condition     = contains(["AUDIT", "BLOCK"], var.wiz_admission_controller_mode)
    error_message = "Enforcement mode must either be 'AUDIT' or 'BLOCK'"
  }
}

variable "wiz_admission_controller_policies" {
  type        = list(string)
  description = "A list of strings representing the Wiz Admission Controller policies that should be enforced."
  default     = []
}

variable "wiz_k8s_integration_client_id" {
  type        = string
  description = "A string representing the Client ID for the Wiz Sensor service account."
  default     = ""
}

variable "wiz_k8s_integration_client_secret" {
  type        = string
  description = "A string representing the Client Secret for the Wiz Sensor service account."
  default     = ""
}

variable "wiz_sensor_pull_username" {
  type        = string
  description = "A string representing the image pull username for Wiz container images."
  default     = ""
}

variable "wiz_sensor_pull_password" {
  type        = string
  description = "A string representing the image pull password for Wiz container images."
  default     = ""
}

variable "use_wiz_admission_controller" {
  type        = bool
  description = "A boolean representing whether or not to deploy the Wiz Admission Controller in the EKS cluster."
  default     = false
}

variable "use_wiz_sensor" {
  type        = bool
  description = "A boolean representing whether or not to deploy the Wiz Sensor in the EKS cluster."
  default     = false
}
