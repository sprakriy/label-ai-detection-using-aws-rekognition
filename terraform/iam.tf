data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "rekognition_lambda_role" {
  name               = "rekognition_processor_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}
data "aws_iam_policy_document" "lambda_permissions" {
    statement {
        actions = [
        "s3:GetObject",
        ]
        resources = ["${data.aws_s3_bucket.existing_bucket.arn}/*"]
    }
    
    statement {
        actions = [
        "rekognition:DetectLabels",
        "rekognition:DetectText"
        ]
        resources = ["*"]
    }
    statement {
        actions = ["dynamodb:PutItem"]
        resources = ["${aws_dynamodb_table.labels_table.arn}"]
    }
    statement {
        actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        resources = ["arn:aws:logs:*:*:*"]
    }
}
    resource "aws_iam_role_policy" "lambda_policy" {
    name   = "rekognition-processor-policy"
    role = aws_iam_role.rekognition_lambda_role.id
    policy = data.aws_iam_policy_document.lambda_permissions.json
    }