import sys
import os
import json
import boto3
from moto import mock_aws

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../../functions/order_ingest'))


@mock_aws
def test_order_ingest():
    s3 = boto3.client("s3", region_name="us-east-1")
    sqs = boto3.client("sqs", region_name="us-east-1")

    bucket_name = "test-bucket"
    s3.create_bucket(Bucket=bucket_name)
    queue = sqs.create_queue(QueueName="test-queue")
    queue_url = queue["QueueUrl"]

    os.environ["ORDER_BUCKET"] = bucket_name
    os.environ["ORDER_QUEUE_URL"] = queue_url

    import importlib
    import handler
    importlib.reload(handler)

    event = {"body": json.dumps({"product": "laptop", "quantity": 2})}
    result = handler.lambda_handler(event, None)

    assert result["statusCode"] == 200
    body = json.loads(result["body"])
    assert "order_id" in body