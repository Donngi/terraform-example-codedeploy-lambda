# ----------------------------------------------------------
# CodeDeploy resources
# ----------------------------------------------------------

resource "aws_codedeploy_app" "sample" {
  compute_platform = "Lambda"
  name             = "SampleApp"
}

resource "aws_codedeploy_deployment_group" "sample" {
  app_name              = aws_codedeploy_app.sample.name
  deployment_group_name = "SampleDeploymentGroup"
  service_role_arn      = aws_iam_role.codedeploy_deployment_group_sample.arn

  deployment_config_name = "CodeDeployDefault.LambdaLinear10PercentEvery2Minutes"
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
}

# ----------------------------------------------------------
# Trigger of deployment
# ----------------------------------------------------------

resource "null_resource" "run_codedeploy" {
  triggers = {
    # Run codedeploy when lambda version is updated
    lambda_version = var.lambda_version
  }

  provisioner "local-exec" {
    # Only trigger deploy when lambda version is updated (=lambda version is not 1)
    command = "if [ ${var.lambda_version} -ne 1 ] ;then aws deploy create-deployment --application-name ${aws_codedeploy_app.sample.name} --deployment-group-name ${aws_codedeploy_deployment_group.sample.deployment_group_name} --revision '{\"revisionType\":\"AppSpecContent\",\"appSpecContent\":{\"content\":\"{\\\"version\\\":0,\\\"Resources\\\":[{\\\"${var.lambda_function_name}\\\":{\\\"Type\\\":\\\"AWS::Lambda::Function\\\",\\\"Properties\\\":{\\\"Name\\\":\\\"${var.lambda_function_name}\\\",\\\"Alias\\\":\\\"${var.lambda_alias_name}\\\",\\\"CurrentVersion\\\":\\\"${var.lambda_alias_version}\\\",\\\"TargetVersion\\\":\\\"${var.lambda_version}\\\"}}}]}\"}}';fi"
  }
}
