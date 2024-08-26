from aws_cdk import core
from custom_iam_policy import CustomIAMPolicy

import os

app = core.App()
env:dict = {
    "region": os.environ["CDK_DEFAULT_REGION"],
    "account": os.environ["CDK_DEFAULT_ACCOUNT"],
}
pjt_name:str='XXXXXXXX'

# Stack
auto_stop_ec2_stack = CustomIAMPolicy(
    app,
    "CustomIAMPolicyStack",
    pjt_name=pjt_name,
    env=env
)

app.synth()
