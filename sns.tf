resource "aws_sns_topic" "orders" {
  name = "${var.project_name}-notifications"
}