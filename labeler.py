import boto3

# Initialize clients
s3 = boto3.client('s3')
rekognition = boto3.client('rekognition', region_name='us-east-1') # Change region as needed

BUCKET = 'label-bkt-for-ai-04282026' # Your bucket name
IMAGE = 'sig-img-04282026.jpg' # Upload this image to your bucket first

def analyze_image():
    # Call Rekognition
    response = rekognition.detect_labels(
        Image={
            'S3Object': {
                'Bucket': BUCKET,
                'Name': IMAGE
            }
        },
        MaxLabels=10,
        MinConfidence=80
    )

    print(f'Labels detected for {IMAGE}:')
    for label in response['Labels']:
        print(f"{label['Name']} - Confidence: {label['Confidence']:.2f}%")

if __name__ == "__main__":
    analyze_image()
