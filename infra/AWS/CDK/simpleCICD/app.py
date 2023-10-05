from aws_cdk import (
    core,
    aws_codecommit as codecommit,
    aws_codebuild as codebuild,
    aws_codepipeline as codepipeline,
    aws_codepipeline_actions as codepipeline_actions,
    aws_iam as iam,
    aws_s3 as s3,
)
import os



class SimpleCodePipeline(core.Stack):

    def __init__(self, scope: core.App, name: str, **kwargs) -> None:
        super().__init__(scope, name, **kwargs)

        # デプロイ先のS3バケット名
        s3_bucket_name = "test-bucket-code-commit"


        # ファイル置き場
        target_bucket = s3.Bucket(
            self, "target-bucket",
            bucket_name=s3_bucket_name, # 一意なバケット名を指定可能
            public_read_access=False, 
            removal_policy=core.RemovalPolicy.DESTROY,# cdk destroyした際にバケットも含めて削除
        )
        
        # リポジトリ名
        repo_name = "test_repo"

        # CodeCommitのRepository作成
        repo = codecommit.Repository(
            self,
            "Repository",
            repository_name=repo_name,
            description="test."
        )
        
        # 20220723_from_repository_arnだとうまくいかないため、メソッドを変更
        repository = codecommit.Repository.from_repository_name(self, repo_name, repo.repository_name)

        # CodePipelineの定義
        pipeline = codepipeline.Pipeline(
            self,
            id=f"test-pipeline-{repo_name}",
            pipeline_name=f"test-pipeline-{repo_name}"
        )
        source_output = codepipeline.Artifact('source_output')

        # トリガーとするcodecommitへのアクションを定義
        source_action =  codepipeline_actions.CodeCommitSourceAction(
            repository=repository,
            branch='master',
            action_name='source_collect_action_from_codecommit',
            output=source_output,
            trigger=codepipeline_actions.CodeCommitTrigger.EVENTS
        )
        pipeline.add_stage(stage_name='Source', actions=[source_action])

        # Codebuildの内容を定義（今回のケースではローカルファイルをS3にSync転送）
        cdk_build = codebuild.PipelineProject(
            self,
            "CdkBuild",
            build_spec=codebuild.BuildSpec.from_object(
                dict(
                    version="0.2",
                    phases=dict(
                        build=dict(
                            commands=[f"aws s3 sync ./ s3://{s3_bucket_name}/"]
                        )
                    )
                )
            )
        )
        
        # codebuildの権限追加（S3操作権限付与）
        cdk_build.add_to_role_policy(
            iam.PolicyStatement(
                resources=[f'arn:aws:s3:::{s3_bucket_name}', f'arn:aws:s3:::{s3_bucket_name}/*'],
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
SimpleCodePipeline(
    app, "SimpleCodePipeline",
    env={
        "region": os.environ["CDK_DEFAULT_REGION"],
        "account": os.environ["CDK_DEFAULT_ACCOUNT"],
    }
)
app.synth()
