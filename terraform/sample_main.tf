locals {
  name_prefix = "${var.app_name}-${var.environment}"
}

# S3 bucket (for labs 1, 3, 7 etc.)
resource "aws_s3_bucket" "input" {
  bucket = "${local.name_prefix}-input"
}

# SNS topic
resource "aws_sns_topic" "notifications" {
  name = "${local.name_prefix}-notifications"
}

# SQS queue (for order & worker style labs)
resource "aws_sqs_queue" "orders" {
  name                      = "${local.name_prefix}-orders"
  visibility_timeout_seconds = 60
}

# Aurora Serverless v2 (MySQL or Postgres)
resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${local.name_prefix}-aurora"
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  database_name           = "appdb"
  master_username         = var.aurora_username
  master_password         = var.aurora_password
  backup_retention_period = 1
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier         = "${local.name_prefix}-aurora-instance-1"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.serverless"
}

# Lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = "${local.name_prefix}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Core Lambda (varies by lab: processor, worker, scheduler, etc.)
resource "aws_lambda_function" "core" {
  function_name = "${local.name_prefix}-core"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.handler"
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      AURORA_ENDPOINT     = aws_rds_cluster.aurora.endpoint
      SNS_TOPIC_ARN       = aws_sns_topic.notifications.arn
      ORDERS_QUEUE_URL    = aws_sqs_queue.orders.id
      APP_ENV             = var.environment
    }
  }
}

# EventBridge bus + rule skeleton
resource "aws_cloudwatch_event_bus" "bus" {
  name = "${local.name_prefix}-bus"
}

resource "aws_cloudwatch_event_rule" "rule" {
  name           = "${local.name_prefix}-rule"
  event_bus_name = aws_cloudwatch_event_bus.bus.name
  event_pattern  = <<EOF
{
  "source": ["${local.name_prefix}"]
}
EOF
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "lambda-core"
  arn       = aws_lambda_function.core.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.core.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rule.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.core.arn
}

output "aurora_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "eventbridge_bus_arn" {
  value = aws_cloudwatch_event_bus.bus.arn
}
