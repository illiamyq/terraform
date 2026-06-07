import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../functions/order_processor'))

import json
import boto3
from moto import mock_aws

@mock_aws
def test_order_processor():
    sns = boto3.client("sns", region_name="us-east-1")
    topic = sns.create_topic(Name="test-topic")
    topic_arn = topic["TopicArn"]

    os.environ["SNS_TOPIC_ARN"] = topic_arn

    event = {"order_id": "123", "product": "laptop", "quantity": 2}

    import handler
    result = handler.lambda_handler(event, None)

    assert result["status"] == "processed"