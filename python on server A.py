import boto3
from datetime import datetime

sns_client = boto3.client('sns', region_name='us-east-1')

def publish_message():
    current_time = datetime.utcnow().strftime('%Y-%m-%d-%H:%M:%S')
    message = f"Hello from server A at {current_time}"
    sns_client.publish(
        TopicArn='arn:aws:sns:us-east-1:123456789012:my-sns-topic',
        Message=message
    )

if __name__ == "__main__":
    publish_message()
