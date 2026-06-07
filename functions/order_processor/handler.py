import json
import boto3
import os


def lambda_handler(event, context):
    sns = boto3.client('sns')
    order = event.get('order', event)
    message = f"Order processed: {json.dumps(order)}"
    sns.publish(
        TopicArn=os.environ['SNS_TOPIC_ARN'],
        Message=message,
        Subject='Order Processed'
    )
    return {
        'status': 'processed',
        'order': order
    }