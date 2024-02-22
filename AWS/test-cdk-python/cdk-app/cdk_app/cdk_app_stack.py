from aws_cdk import (
    Stack,
    aws_s3 as s3,
    RemovalPolicy,
    CfnOutput,
    aws_iam as iam,
    aws_dynamodb as dy_db,
    aws_lambda as _lambda,
    aws_lambda_event_sources as event_sources,
)
from constructs import Construct

# from aws_cdk import App
# from cdk_app.cdk_app_stack import CdkAppStack


class CdkAppStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        #################### S3 bucket ###################
        bucket = s3.Bucket(self, 'image_bucket', removal_policy=RemovalPolicy.DESTROY)
        CfnOutput(self, 'Bucket', value=bucket.bucket_name)


        ######################## IAM Roles###########################
        assumedBy = iam.ServicePrincipal('lambda.amazonaws.com')
        role = iam.Role(self, 'cdk_lambdarole_MEN', assumed_by=assumedBy)
        
        lambda_policies = iam.PolicyStatement(
            effect=iam.Effect.ALLOW,
            actions= [
                "rekognition:*",
                "logs:CreateLogGroup",
                'logs:CreateLogStream',
                "logs:PutLogEvents",
            ],
            resources= ["*"],
        )
        role.add_to_policy(lambda_policies)

        ####################### DynamoDB #############################
        table = dy_db.Table(self, 'cdk_table', partition_key={
            'name': 'Image',
            'type': dy_db.AttributeType.STRING
        }, removal_policy=RemovalPolicy.DESTROY)

        CfnOutput(self, "Table", value=table.table_name)

        ######################## Lambda Function ##################################
        lambda_fn = _lambda.Function(self, "cdk-function",
            code= _lambda.Code.from_asset('lambda'),
            runtime=_lambda.Runtime.PYTHON_3_10,
            handler='lf.handler',
            role=role,
            environment={
                "TABLE": table.table_name,
                "BUCKET": bucket.bucket_name
            }                         
        )

        lambda_fn.add_event_source(
            event_sources.S3EventSource(bucket, events=[s3.EventType.OBJECT_CREATED])
        )

        bucket.grant_read_write(lambda_fn)
        table.grant_full_access(lambda_fn)

# app = App()
# CdkAppStack(app, "CdkAppStack")
# app.synth()