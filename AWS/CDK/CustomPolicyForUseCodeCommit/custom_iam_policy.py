from aws_cdk import (
    core,
    aws_iam as iam,
)
from aws_cdk.core import Stack
import json

class CustomIAMPolicy(Stack): 
    def __init__(self, scope: core.App, name: str, pjt_name: str,**kwargs) -> None:
        super().__init__(scope, name, **kwargs)

        # get param
        repository_name = core.CfnParameter(self
            ,'RepositoryName'
            , type='String'
            , description='repository_name'                                                                                             
        )
        # env
        env = kwargs['env']
        
        # setting
        group_string = "group"
        manager_role_policy_group_name = "Codecommit{}ForManager"
        user_role_policy_group_name = "Codecommit{}ForUser"

        # グループの作成
        manager_group = self._build_group(manager_role_policy_group_name.format(group_string))
        user_group = self._build_group(user_role_policy_group_name.format(group_string))
        
        # repository arn
        repository_arn = f"arn:aws:codecommit:{env['region']}:{env['account']}:{repository_name.value_as_string}"

        # load json AWS管理ベースpolicy
        # IP制限の条件含む
        json_policy_based_full_accsess, json_policy_based_power_accsess = self._load_json_policy(repository_arn)
        policy_doc_based_full_access = iam.PolicyDocument.from_json(json_policy_based_full_accsess)
        policy_doc_based_power_access = iam.PolicyDocument.from_json(json_policy_based_power_accsess)
        
        # policyをアタッチ
        manager_group.attach_inline_policy(iam.Policy(self,'PolicyBasedOnCodeCommitFullAccess',document=policy_doc_based_full_access))
        user_group.attach_inline_policy(iam.Policy(self,'PolicyBasedOnCodeCommitPowerUser',document=policy_doc_based_power_access))

        # policyをアタッチ
        # custom_policy：masterへのプッシュ・マージを拒否 一般のみ 
        custom_policy_deny_merge = iam.Policy(
            self,
            id="id_custom_policy_deny_action_for_master_branch",
            policy_name="CustomPolicyDenyActionForMasterBranch",
            groups=[user_group],
            statements=[
                iam.PolicyStatement(
                    effect=iam.Effect.DENY,
                    actions=[
                        "codecommit:GitPush",
                        "codecommit:DeleteBranch",
                        "codecommit:PutFile",
                        "codecommit:MergeBranchesByFastForward",
                        "codecommit:MergeBranchesBySquash",
                        "codecommit:MergeBranchesByThreeWay",
                        "codecommit:MergePullRequestByFastForward",
                        "codecommit:MergePullRequestBySquash",
                        "codecommit:MergePullRequestByThreeWay"
                    ],
                    resources = [repository_arn], #　変更
                    conditions={
                        "StringEqualsIfExists": {
                            "codecommit:References": [
                                "refs/heads/main", 
                                "refs/heads/master",
                            ]
                        },
                        "Null": {
                            "codecommit:References": "false"
                        }
                    }
                )
            ]
        )


    def _build_group(self,group_name:str)->iam.Group:
        return iam.Group(
            self
            , id=f"id_group_{group_name}"
            , group_name=f"group_{group_name}"
        )


    def _load_json_policy(self,repository_arn:str)->list:
        file_policy_based_full_accsess = './json/PolicyBasedOnAWSCodeCommitFullAccess.json'
        file_policy_based_power_user_accsess = './json/PolicyBasedOnAWSCodeCommitPowerUser.json'

        # 操作対象のリポジトリを制限する
        jsons = []
        for file_path in [file_policy_based_full_accsess, file_policy_based_power_user_accsess]:
            with open(file_path,"r") as file:
                load_json = json.load(file)
                load_json["Statement"][0]["Resource"] = repository_arn
            jsons.append(load_json)
        return jsons