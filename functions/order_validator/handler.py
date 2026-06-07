import json

def lambda_handler(event, context):
    order = event.get('order', event)

    required_fields = ['order_id', 'product', 'quantity']
    for field in required_fields:
        if field not in order:
            return {
                'valid': False,
                'reason': f'Missing field: {field}',
                'order': order
            }

    if not isinstance(order['quantity'], int) or order['quantity'] <= 0:
        return {
            'valid': False,
            'reason': 'Invalid quantity',
            'order': order
        }

    return {'valid': True, 'order': order}