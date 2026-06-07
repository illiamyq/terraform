resource "aws_sfn_state_machine" "order_pipeline" {
  name     = "${var.project_name}-state-machine"
  role_arn = data.aws_iam_role.lab_role.arn

  definition = jsonencode({
    Comment = "Order processing pipeline"
    StartAt = "ValidateOrder"
    States = {
      ValidateOrder = {
        Type     = "Task"
        Resource = aws_lambda_function.order_validator.arn
        Next     = "CheckValid"
      }
      CheckValid = {
        Type = "Choice"
        Choices = [
          {
            Variable      = "$.valid"
            BooleanEquals = true
            Next          = "ProcessOrder"
          }
        ]
        Default = "OrderInvalid"
      }
      ProcessOrder = {
        Type     = "Task"
        Resource = aws_lambda_function.order_processor.arn
        End      = true
      }
      OrderInvalid = {
        Type  = "Fail"
        Error = "InvalidOrder"
        Cause = "Order failed validation"
      }
    }
  })
}