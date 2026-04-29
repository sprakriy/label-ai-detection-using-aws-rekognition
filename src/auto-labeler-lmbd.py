import boto3
import json
import urllib.parse

# Initialize clients outside the handler for better performance (Warm Starts)
rekognition = boto3.client('rekognition')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ImageLabels')  # Ensure this DynamoDB table exists

def lambda_handler(event, context):
    # 1. Get the bucket and object key from the S3 event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'])

    try:
        # 2. Call Rekognition DetectLabels
        response = rekognition.detect_labels(
            Image={'S3Object': {'Bucket': bucket, 'Name': key}},
            MaxLabels=10
        )

        # 3. Format data for DynamoDB
        labels = [{ "Name": l['Name'], "Confidence": str(l['Confidence']) } for l in response['Labels']]
        
        # 4. Persist Result
        table.put_item(
            Item={
                'ImageName': key,
                'Labels': labels,
                'Status': 'Processed'
            }
        )

        return {"status": "success", "file": key}

    except Exception as e:
        print(f"Error processing {key}: {str(e)}")
        raise e