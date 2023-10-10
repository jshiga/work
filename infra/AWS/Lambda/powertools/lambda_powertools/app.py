import json
from aws_lambda_powertools import Logger
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger()
app = APIGatewayRestResolver()

@app.get("/products")
def get_products():
    products={
        "products":[
            {"id":"1","name":"01","price":100},
            {"id":"2","name":"02","price":200},
            {"id":"3","name":"03","price":300},
        ]
    }
    return products


@logger.inject_lambda_context(correlation_id_path=correlation_paths.API_GATEWAY_REST)
def lambda_handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)