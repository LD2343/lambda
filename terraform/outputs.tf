output "lambda_function_arn" {
  value = module.serverless_app.lambda_function_arn
}

output "aurora_endpoint" {
  value = module.serverless_app.aurora_endpoint
}

output "eventbridge_bus_arn" {
  value = module.serverless_app.eventbridge_bus_arn
}
