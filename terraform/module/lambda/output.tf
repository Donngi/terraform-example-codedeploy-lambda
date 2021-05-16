output "lambda_function_name" {
  value = aws_lambda_function.sample.function_name
}

output "lambda_version" {
  value = aws_lambda_function.sample.version
}

output "lambda_alias_name" {
  value = aws_lambda_alias.sample.name
}

output "lambda_alias_version" {
  value = aws_lambda_alias.sample.function_version
}
