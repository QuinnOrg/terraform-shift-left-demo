module "default_shift_left_environment" {
  source = "../../"

  argocd_application_name      = "mighty-quinn"
  argocd_application_namespace = "mighty-quinn"
  git_repo_url                 = "https://github.com/justinquinn21/sample_CI-CD.git"
  git_repo_manifest_path       = "manifests"

  wiz_k8s_integration_client_id     = "wgxq75hrlndpbktx3eupevf2xywdbs7llunfy6u4zub24qwebkdwm"
  wiz_k8s_integration_client_secret = "85U2vFJoiguXcUd6MWPBRepNUPKBckYmhW7TTo8FJYY3whB9QvHYHzsoys1BnoR5"

  use_wiz_admission_controller = true
  
  wiz_admission_controller_mode = "AUDIT"
  wiz_admission_controller_policies = ["JustinQuinnACPolicy"]

  use_wiz_image_trust = true
  wiz_image_trust_policies = ["justin-image-trust"]

  use_wiz_k8s_audit_logs = true

  use_wiz_sensor           = true
  wiz_sensor_pull_username = "wizio-repo-b1af0ff4-f15b-46f0-aa77-d928f254babe"
  wiz_sensor_pull_password = "1mKRv3oL/kIMWl+ygFJBWvpc6ch50owxKS9satjfZd+ACRAkz79n"
}

output "shift_left_environment_output" {
  value = module.default_shift_left_environment
}