# Zip the source code automatically
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../src/auto-labeler-lmbd.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "rekognition_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "rekognition-processor"
  role             = aws_iam_role.rekognition_lambda_role.arn
  handler          = "auto-labeler-lmbd.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# S3 Trigger Permission (Allows S3 to call this specific Lambda)
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rekognition_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.existing_bucket.arn
}

# S3 Bucket Notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.existing_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.rekognition_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg" # Only trigger for JPEGs
  }

  depends_on = [aws_lambda_permission.allow_s3]
}