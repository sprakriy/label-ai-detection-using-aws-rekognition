# label-ai-detection-using-aws-rekognition
AWS Event-Driven AI Image Processing Pipeline
Project Overview
This project demonstrates a fully automated, serverless pipeline for image analysis using Infrastructure as Code (Terraform). When an image is uploaded to an S3 bucket, a Lambda function is triggered to analyze the image using Amazon Rekognition. The extracted metadata (labels and confidence scores) is then persisted into an Amazon DynamoDB table for downstream consumption.

Key Technical Features
Infrastructure as Code: 100% of the AWS environment (S3, IAM, Lambda, DynamoDB) is provisioned and managed via Terraform.

Event-Driven Architecture: Utilizes S3 Bucket Notifications to trigger compute resources only when needed, minimizing costs.

Least Privilege Security: Custom IAM Identity-Based policies scoped strictly to the specific DynamoDB table ARN and S3 bucket.

Automated Lifecycle: Supports full terraform apply and terraform destroy operations for consistent environment management.

System Architecture
Storage: Amazon S3 acts as the entry point for raw image data.

Compute: AWS Lambda (Python 3.11/Boto3) processes events and coordinates service calls.

AI/ML: Amazon Rekognition performs object and text detection.

Database: Amazon DynamoDB stores analyzed metadata in a NoSQL format.

Technical Challenges & Solutions
IAM Scoping: Resolved AccessDeniedException by aligning Terraform-generated resource ARNs with Lambda execution role policies.

Environment Parity: Ensured consistency between Terraform resource naming conventions (underscores) and Python Boto3 client requests (dashes/hardcoded identifiers).

State Management: Managed S3 bucket cleanup protocols to ensure clean Terraform destroy operations.

Prerequisites
Terraform v1.0+

AWS CLI configured with appropriate permissions

Python 3.11

How to Deploy
Initialize: terraform init

Deploy: terraform apply

Test: Upload a .jpg or .png to the created S3 bucket.

Verify: Check the DynamoDB table for generated labels.

Cleanup: terraform destroy