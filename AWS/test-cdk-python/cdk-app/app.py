import aws_cdk as cdk

from cdk_app.cdk_app_stack import CdkAppStack

app = cdk.App()
CdkAppStack(app, 'fuck-CDK')
app.synth()