module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  cluster_name           = module.eks.cluster_name
  irsa_oidc_provider_arn = module.eks.oidc_provider_arn

  policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags
}

resource "time_sleep" "wait_for_cluster" {
  depends_on = [module.eks]

  create_duration  = var.cluster_wait
  destroy_duration = var.cluster_wait
}

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "${path.module}/charts"
  chart      = "karpenter"

  set {
    name  = "settings.aws.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.irsa_arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = module.karpenter.queue_name
  }

  lifecycle {
    ignore_changes = [
      repository_password
    ]
  }

  depends_on = [
    data.aws_eks_cluster_auth.eks_cluster,
    time_sleep.wait_for_cluster
  ]
}

resource "helm_release" "karpenter_configuration" {
  name       = "karpenter-configuration"
  namespace  = "karpenter"
  repository = "https://bedag.github.io/helm-charts/"
  chart      = "raw"
  version    = "2.0.0"
  values = [
    <<-EOF
    resources:
      - apiVersion: karpenter.sh/v1alpha5
        kind: Provisioner
        metadata:
          name: default
        spec:
          requirements:
            - key: karpenter.sh/capacity-type
              operator: In
              values: ["spot"]
          limits:
            resources:
              cpu: 1000
          providerRef:
            name: default
          ttlSecondsAfterEmpty: 30

      - apiVersion: karpenter.k8s.aws/v1alpha1
        kind: AWSNodeTemplate
        metadata:
          name: default
        spec:
          subnetSelector:
            karpenter.sh/discovery: ${module.eks.cluster_name}
          securityGroupSelector:
            karpenter.sh/discovery: ${module.eks.cluster_name}
          tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
    EOF
  ]

  depends_on = [
    helm_release.karpenter
  ]
}
