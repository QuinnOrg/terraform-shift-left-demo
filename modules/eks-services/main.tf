resource "random_id" "uniq" {
  byte_length = 4
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  timeouts {
    delete = "30m"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.id

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "kubernetes_namespace" "wiz" {
  metadata {
    name = var.wiz_namespace
  }
}

resource "helm_release" "wiz_k8s_integration_argocd" {
  name       = "wiz-k8s-argocd-application"
  namespace  = kubernetes_namespace.argocd.id
  repository = "https://bedag.github.io/helm-charts/"
  chart      = "raw"
  version    = "2.0.0"
  values = [
    <<-EOF
    resources:
      - apiVersion: argoproj.io/v1alpha1
        kind: Application
        metadata:
          name: wiz-k8s-integration
          namespace: ${kubernetes_namespace.argocd.id}
          finalizers:
          - resources-finalizer.argocd.argoproj.io
        spec:
          project: default
          source:
            repoURL: 'https://wiz-sec.github.io/charts'
            targetRevision: 0.*
            helm:
              values: |+
                global:
                  wizApiToken:
                    clientId: ${var.wiz_k8s_integration_client_id}
                    clientToken: ${var.wiz_k8s_integration_client_secret}

                wiz-admission-controller:
                  enabled: ${var.use_wiz_admission_controller}
                  webhook:
                    errorEnforcementMethod: ${var.wiz_admission_controller_mode}
                    policyEnforcementMethod: ${var.wiz_admission_controller_mode}

                  opaWebhook:
                    policies: ${jsonencode(var.wiz_admission_controller_policies)}

                  imageIntegrityWebhook:
                    enabled: true
                    policies:
                    - Justin Image Trust

                  kubernetesAuditLogsWebhook:
                    enabled: ${var.use_wiz_k8s_audit_logs}

                wiz-kubernetes-connector:
                  enabled: true
                  broker:
                    enabled: false
                  autoCreateConnector:
                    connectorName: ${local.kubernetes_connector_name}
                    clusterFlavor: EKS
                    apiServerEndpoint: ${var.k8s_endpoint}

                wiz-sensor:
                  enabled: ${var.use_wiz_sensor}
                  imagePullSecret:
                    username: ${var.wiz_sensor_pull_username}
                    password: ${var.wiz_sensor_pull_password}

            chart: wiz-kubernetes-integration
          destination:
            server: 'https://kubernetes.default.svc'
            namespace: ${kubernetes_namespace.wiz.id}
          syncPolicy:
            automated:
              prune: true
              selfHeal: true
            syncOptions:
              - PruneLast=true
              - RespectIgnoreDifferences=true
              - ServerSideApply=true
              - CreateNamespace=true
    EOF
  ]

  depends_on = [
    helm_release.argocd
  ]
}
