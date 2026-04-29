resource "aws_dynamodb_table" "labels_table" {
  name         = "ImageLabels"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ImageName"

  attribute {
    name = "ImageName"
    type = "S" # String
  }

  tags = {
    Environment = "Dev"
    Project     = "Rekognition-Pipeline"
  }
}
data "aws_s3_bucket" "existing_bucket" {
  bucket = "label-bkt-for-ai-04282026"
}