data "archive_file" "sample" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/upload/lambda.zip"
}

resource "aws_lambda_function" "sample" {
  filename      = data.archive_file.sample.output_path
  function_name = "SampleLambdaWithCodeDeploy"
  role          = aws_iam_role.lambda_sample.arn
  handler       = "main.lambda_handler"

  source_code_hash = data.archive_file.sample.output_base64sha256

  runtime = "python3.8"

  tracing_config {
    mode = "Active" # Activate AWS X-Ray
  }

  environment {
    variables = {
      SAMPLE_ENV = "SAMPLE_VALUE"
    }
  }

  timeout = 29
  publish = true
}

resource "aws_lambda_alias" "sample" {
  name             = var.lambda_alias_name
  function_name    = aws_lambda_function.sample.function_name
  function_version = "1"

  # To use CodeDeploy, ignore change of function_version
  lifecycle {
    ignore_changes = [function_version, routing_config]
  }

}
