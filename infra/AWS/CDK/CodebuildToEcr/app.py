from typing import Any, Type
from dataclasses import dataclass, field, asdict
from aws_cdk.core import RemovalPolicy
from aws_cdk import core
from aws_cdk.aws_ecr import Repository

from src.entity.ecr_entity import SampleEcr
from src.stack.ecr_stack import EcrStack
from src.entity.ecr_entity import EcrBase

from aws_cdk import (
    core,
    aws_codecommit as codecommit,
    aws_codebuild as codebuild,
    aws_codepipeline as codepipeline,
    aws_codepipeline_actions as codepipeline_actions,
    aws_iam as iam,
    aws_ecr as ecr,
    aws_s3 as s3,
    aws_cloudtrail as cloudtrail
)

import os

class SampleEcrBuildTest(core.Stack):
    def __init__(self,scope: core.Construct, name: str, entity: Type[EcrBase], **kwargs: Any) -> None:
        super().__init__(scope, name, **kwargs)
        
        # ecrレポジトリ        
        params = asdict(entity.repository)    
        repo = Repository(
            self 
            , **params
        )

        # パイプラインの生成
        pipeline = codepipeline.Pipeline(
            self,
            id=f'test-pipeline-{params["repository_name"]}',
            pipeline_name=f'test-pipeline-{params["repository_name"]}'
        )
        
        # s3_action
        bucket_name = 'MyBucket'
        source_bucket = s3.Bucket(
            self, 
            bucket_name,versioned=True,
            removal_policy=core.RemovalPolicy.DESTROY,
        )
        source_output = codepipeline.Artifact('CdkSourceS3')
        
        # trail
        key = "artifact.zip" # Buildspec含むファイルdeploy用ファイル群
        trail = cloudtrail.Trail(self, "CloudTrail")
        trail.add_s3_event_selector(
            [
                cloudtrail.S3EventSelector(
                    bucket=source_bucket,
                    object_prefix=key
                )
            ],
           read_write_type=cloudtrail.ReadWriteType.WRITE_ONLY
        )
        
        s3_action = codepipeline_actions.S3SourceAction(
            action_name="S3Source",
            bucket=source_bucket,
            bucket_key=key,
            output=source_output,
            trigger=codepipeline_actions.S3Trigger.EVENTS
        )
        
        pipeline.add_stage(
            stage_name="s3_trriger",
            actions=[s3_action]
        )
        

        # codeBuildのプロジェクトの生成
        cdk_build = codebuild.Project(
            self, 
            "CdkBuild",
             build_spec=codebuild.BuildSpec.from_source_filename('buildspec.yml')
            , source=codebuild.Source.s3(
                bucket=source_bucket,
                path=key
            )
        )
        # codebuildの権限追加（S3操作権限付与）
        bucket_arn = f'arn:aws:s3:::{bucket_name}'
        cdk_build.add_to_role_policy(
            iam.PolicyStatement(
                resources=[bucket_arn],
                actions=['s3:*']
            )
        )

        build_output = codepipeline.Artifact("CdkBuildOutput")
        build_action = codepipeline_actions.CodeBuildAction(
            action_name="CDK_Build",
            project=cdk_build,
            input=source_output,
            outputs=[build_output]
        )
        pipeline.add_stage(
            stage_name="Build",
            actions=[build_action]
        )
        


app = core.App()
SampleEcrBuildTest(
    app
    , "SampleEcrBuildTest"
    , entity=SampleEcr
    , env={
        "region": os.environ["CDK_DEFAULT_REGION"],
        "account": os.environ["CDK_DEFAULT_ACCOUNT"],
    }
)
app.synth()