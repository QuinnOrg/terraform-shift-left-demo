module "eks_cluster" {
  source = "./modules/eks-cluster"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  access_entries          = var.access_entries
  cluster_admins          = var.eks_cluster_admins
  cluster_version         = var.eks_cluster_version
  karpenter_chart_verison = var.karpenter_chart_verison
  region                  = var.region
  resource_prefix         = var.resource_prefix
}

module "eks_services" {
  source = "./modules/eks-services"

  resource_prefix = var.resource_prefix

  k8s_ca_certificate = module.eks_cluster.ca_certificate
  k8s_endpoint       = module.eks_cluster.endpoint
  k8s_token          = module.eks_cluster.token

  wiz_k8s_integration_client_id     = var.wiz_k8s_integration_client_id
  wiz_k8s_integration_client_secret = var.wiz_k8s_integration_client_secret

  use_wiz_admission_controller      = var.use_wiz_admission_controller
  wiz_admission_controller_mode     = var.wiz_admission_controller_mode
  wiz_admission_controller_policies = var.wiz_admission_controller_policies
  use_wiz_image_trust               = var.use_wiz_image_trust
  wiz_image_trust_policies          = var.wiz_image_trust_policies
  use_wiz_k8s_audit_logs            = var.use_wiz_k8s_audit_logs

  use_wiz_sensor           = var.use_wiz_sensor
  wiz_sensor_pull_username = var.wiz_sensor_pull_username
  wiz_sensor_pull_password = var.wiz_sensor_pull_password

  depends_on = [module.eks_cluster]
}

resource "time_sleep" "argo_wait" {
  depends_on = [module.eks_services]

  destroy_duration = var.argocd_destroy_wait
}

resource "kubectl_manifest" "argo_cd_application" {
  count = var.deploy_argocd_application ? 1 : 0

  yaml_body = <<-YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: ${var.argocd_application_name}
      namespace: argocd
      finalizers:
      - resources-finalizer.argocd.argoproj.io
    spec:
      project: default
      source:
        repoURL: ${var.git_repo_url}
        targetRevision: HEAD
        path: ${var.git_repo_manifest_path}
      destination:
        server: https://kubernetes.default.svc
        namespace: ${var.argocd_application_namespace}
      syncPolicy:
        automated:
          prune: true
          allowEmpty: true
        syncOptions:
        - CreateNamespace=true
        - PruneLast=true
  YAML

  depends_on = [
    module.eks_services,
    time_sleep.argo_wait
  ]
}
