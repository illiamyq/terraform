output "api_endpoint" {
  value       = "${aws_api_gateway_stage.prod.invoke_url}/orders"
  description = "POST orders to this URL"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.orders.id
}

output "sqs_queue_url" {
  value = aws_sqs_queue.orders.url
}

output "sns_topic_arn" {
  value = aws_sns_topic.orders.arn
}

output "state_machine_arn" {
  value = aws_sfn_state_machine.order_pipeline.arn
}