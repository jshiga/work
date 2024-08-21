locals {
    # 設定ファイルをロード
    access_roles_yml = yamldecode(
       file("${path.root}/common/yaml/access_roles.yml")
    )
    functional_roles_yml = yamldecode(
        file("${path.root}/common/yaml/functional_roles.yml")
    )
    access_roles_to_functional_roles_yml = yamldecode(
        file("${path.root}/common/yaml/access_roles_to_functional_roles.yml")
    )
    # Access role のリスト
    access_roles = flatten(local.access_roles_yml["access_roles"])
    # AccessRoleとオブジェクト、Privilegeの紐づけリスト
    grant_on_object_to_access_role = flatten(local.access_roles_yml["grant_on_object_to_access_role"])
    # Functional roleのリスト
    functional_roles = local.functional_roles_yml["functional_roles"]
    # FunctionalRoleとアタッチするユーザの紐づけリスト
    grant_functional_roles_to_user = flatten(local.functional_roles_yml["grant_functional_roles_to_user"])
    # Access roleとFunctional role の紐づけリスト
    grant_access_role_to_functional_role = flatten(local.access_roles_to_functional_roles_yml["grant_access_roles_to_functional_roles"])
}