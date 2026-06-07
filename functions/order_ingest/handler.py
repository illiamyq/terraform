import json
import boto3
import os
import uuid


def lambda_handler(event, context):
    s3 = boto3.client('s3')
    sqs = boto3.client('sqs')
    body = json.loads(event.get('body', '{}'))
    order_id = str(uuid.uuid4())
    body['order_id'] = order_id
    s3.put_object(
        Bucket=os.environ['ORDER_BUCKET'],
        Key=f"orders/{order_id}.json",
        Body=json.dumps(body)
    )
    sqs.send_message(
        QueueUrl=os.environ['ORDER_QUEUE_URL'],
        MessageBody=json.dumps(body)
    )
    return {
        'statusCode': 200,
        'body': json.dumps({'order_id': order_id})
    }