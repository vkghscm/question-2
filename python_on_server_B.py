import boto3
import os
from datetime import datetime

sqs_client = boto3.client('sqs', region_name='us-east-1')
s3_client = boto3.client('s3', region_name='us-east-1')

queue_url = 'https://sqs.us-east-1.amazonaws.com/123456789012/my-sqs-queue'
bucket_name = 'question2-s3' 

def receive_message():
    response = sqs_client.receive_message(
        QueueUrl=queue_url,
        MaxNumberOfMessages=1,
        WaitTimeSeconds=30
    )
   
    messages = response.get('Messages', [])
    if messages:
        for message in messages:
            receipt_handle = message['ReceiptHandle']
            body = message['Body']
           
            # Write the message to a file
            current_time = datetime.utcnow().strftime('%Y-%m-%d-%H:%M:%S')
            file_name = f"{current_time}-message.log"
            with open(file_name, 'w') as file:
                file.write(body)
           
            # Upload the file to S3
            s3_client.upload_file(file_name, bucket_name, file_name)
           
            # Delete the message from the queue
            sqs_client.delete_message(
                QueueUrl=queue_url,
                ReceiptHandle=receipt_handle
            )
           
            # Remove the file after uploading to S3
            os.remove(file_name)

if __name__ == "__main__":
    receive_message()
