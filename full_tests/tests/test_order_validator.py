import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../../functions/order_validator'))

import handler

def test_valid_order():
    event = {"order_id": "123", "product": "laptop", "quantity": 2}
    result = handler.lambda_handler(event, None)
    assert result["valid"] == True

def test_missing_field():
    event = {"order_id": "123", "product": "laptop"}
    result = handler.lambda_handler(event, None)
    assert result["valid"] == False

def test_invalid_quantity():
    event = {"order_id": "123", "product": "laptop", "quantity": -1}
    result = handler.lambda_handler(event, None)
    assert result["valid"] == False