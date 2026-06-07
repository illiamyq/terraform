resource "aws_sqs_queue" "orders" {
  name                       = "${var.project_name}-orders"
  visibility_timeout_seconds = 30
}