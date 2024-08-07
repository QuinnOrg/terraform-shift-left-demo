<!-- BEGIN_TF_DOCS -->
# Shift Left Demo Terraform Module

A Terraform module to deploy a "Shift Left" environment and cloud-native application.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.47 |
| helm | >= 2.7 |
| kubectl | >= 2.0 |
| kubernetes | >= 2.10 |
| time | >= 0.10 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.47 |
| kubectl | >= 2.0 |
| kubernetes | >= 2.10 |
| time | >= 0.10 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| eks\_cluster | ./modules/eks-cluster | n/a |
| eks\_services | ./modules/eks-services | n/a |

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.argo_cd_application](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [time_sleep.argo_wait](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [kubernetes_secret_v1.argocd_password](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret_v1) | data source |
| [kubernetes_service.argocd_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_entries | A map representing access entries to add to the EKS cluster. | `any` | `{}` | no |
| argocd\_application\_name | A string representing the ArgoCD application name. (Required if `deploy_argocd_application` is `true`) | `string` | `""` | no |
| argocd\_application\_namespace | A string representing the kubernetes namespace in which to deploy the defined application. (Required if `deploy_argocd_application` is `true`) | `string` | `""` | no |
| argocd\_destroy\_wait | A string represeting the time to wait after destroying ArgoCD applications before cluster teardown should occur. | `string` | `"60s"` | no |
| deploy\_argocd\_application | A boolean representing whether the module should automatically deploy an ArgoCD application. | `bool` | `true` | no |
| eks\_cluster\_admins | A list containing the ARNs of users/roles that should be cluster administrators. | `list(string)` | `[]` | no |
| eks\_cluster\_version | A string representing the desired kubernetes version for the EKS cluster. | `string` | `"1.29"` | no |
| git\_repo\_manifest\_path | A string representing the path within the Git repository where kubernetes manifests for the desired application are stored. (Required if `deploy_argocd_application` is `true`) | `string` | `""` | no |
| git\_repo\_url | A string representing the URL for the Git repository to use for deploying the desired application. (Required if `deploy_argocd_application` is `true`) | `string` | `""` | no |
| karpenter\_chart\_verison | A string representing the version of the Karpenter Helm chart to deploy. | `string` | `"0.35.2"` | no |
| region | A string representing the name of the AWS region to use. | `string` | `"us-east-1"` | no |
| resource\_prefix | A string representing the prefix to use for resource names. | `string` | `"wiz-shift-left"` | no |
| use\_wiz\_admission\_controller | A boolean representing whether or not to deploy the Wiz Admission Controller in the EKS cluster. | `bool` | `false` | no |
| use\_wiz\_k8s\_audit\_logs | A boolean representing whether or not to deploy the Wiz Kubernetes Audit Log proxy in the EKS cluster. | `bool` | `false` | no |
| use\_wiz\_sensor | A boolean representing whether or not to deploy the Wiz Sensor in the EKS cluster. | `bool` | `false` | no |
| wiz\_admission\_controller\_mode | A string representing the mode in which the Wiz Admission Controller should operate. | `string` | `"AUDIT"` | no |
| wiz\_admission\_controller\_policies | A list of strings representing the Wiz Admission Controller policies that should be enforced. | `list(string)` | `[]` | no |
| wiz\_k8s\_integration\_client\_id | A string representing the Client ID for the Wiz Sensor service account. | `string` | `""` | no |
| wiz\_k8s\_integration\_client\_secret | A string representing the Client Secret for the Wiz Sensor service account. | `string` | `""` | no |
| wiz\_sensor\_pull\_password | A string representing the image pull password for Wiz container images. | `string` | `""` | no |
| wiz\_sensor\_pull\_username | A string representing the image pull username for Wiz container images. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| argocd\_password | n/a |
| argocd\_url | n/a |
| kubernetes\_connector\_name | n/a |
<!-- END_TF_DOCS -->