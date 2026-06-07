# zips in order ingests

data "archive_file" "order_ingest_zip" {
  type        = "zip"
  source_dir  = "${path.module}/functions/order_ingest"
  output_path = "${path.module}/builds/order_ingest.zip"
}

data "archive_file" "order_validator_zip" {
  type        = "zip"
  source_dir  = "${path.module}/functions/order_validator"
  output_path = "${path.module}/builds/order_validator.zip"
}

data "archive_file" "order_processor_zip" {
  type        = "zip"
  source_dir  = "${path.module}/functions/order_processor"
  output_path = "${path.module}/builds/order_processor.zip"
}

resource "aws_lambda_function" "order_ingest" {
  function_name    = "order-ingest"
  filename         = data.archive_file.order_ingest_zip.output_path
  source_code_hash = data.archive_file.order_ingest_zip.output_base64sha256
  handler = "ingest_handler.lambda_handler"
  runtime          = "python3.11"
  role             = data.aws_iam_role.lab_role.arn

  environment {
    variables = {
      ORDER_BUCKET    = aws_s3_bucket.orders.id
      ORDER_QUEUE_URL = aws_sqs_queue.orders.url
    }
  }
}

resource "aws_lambda_function" "order_validator" {
  function_name    = "order-validator"
  filename         = data.archive_file.order_validator_zip.output_path
  source_code_hash = data.archive_file.order_validator_zip.output_base64sha256
  handler = "validator_handler.lambda_handler"
  runtime          = "python3.11"
  role             = data.aws_iam_role.lab_role.arn
}

resource "aws_lambda_function" "order_processor" {
  function_name    = "order-processor"
  filename         = data.archive_file.order_processor_zip.output_path
  source_code_hash = data.archive_file.order_processor_zip.output_base64sha256
  handler = "processor_handler.lambda_handler"
  runtime          = "python3.11"
  role             = data.aws_iam_role.lab_role.arn

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.orders.arn
    }
  }
}


resource "aws_cloudwatch_log_group" "order_ingest_logs" {
  name              = "/aws/lambda/order-ingest"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "order_validator_logs" {
  name              = "/aws/lambda/order-validator"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "order_processor_logs" {
  name              = "/aws/lambda/order-processor"
  retention_in_days = 7
}