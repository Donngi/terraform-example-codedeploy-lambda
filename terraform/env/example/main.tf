module "codedeploy" {
  source               = "../../module/codedeploy"
  lambda_function_name = module.lambda.lambda_function_name
  lambda_version       = module.lambda.lambda_version
  lambda_alias_name    = module.lambda.lambda_alias_name
  lambda_alias_version = module.lambda.lambda_alias_version
}

module "lambda" {
  source            = "../../module/lambda"
  lambda_alias_name = "live"
}
