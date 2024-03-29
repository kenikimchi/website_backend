import boto3
import simplejson as json

tableName = 'PageVisitors'
dynamo = boto3.resource('dynamodb').Table(tableName)

print('Loading function')

def lambda_handler(event, context):
    
    params = dynamo.update_item(
        TableName='PageVisitors',
        Key={
            'Index': 0
        },
        UpdateExpression = 'SET VisitorNumber = if_not_exists(VisitorNumber, :initial) + :inc',
        ExpressionAttributeValues = {
            ':inc': 1,
            ':initial': 0
        },
        ReturnValues = "UPDATED_NEW"
    )
        
    
    dynamo.get_item(
        TableName = 'PageVisitors',
        Key = {
            'Index': 0
        },
    )
    
    response = {
        'statusCode': 200,
        'headers': {
            'access-control-allow-headers': 'Content-Type',
            'access-control-allow-origin': '*',
            'access-control-allow-methods': 'OPTIONS, POST, GET',
            'content-type': 'application/json'
        },
        'body': json.dumps(params)
    }
    
    return response