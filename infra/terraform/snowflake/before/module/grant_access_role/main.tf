locals {
    filtered_map_access_role = {for key,val in var.roles_name_descript_dict : key=>val if startswith(key, "access_role_")}
    # contains関数を利用すると、次のエラーが発生する。Returnが配列でない場合には採用できない：Call to function "contains" failed: argument must be list, tuple, or set.
    read_write_keys = [for k in keys(var.roles_name_descript_dict) : k if can(regex("_RW", k))]
}

# access role すべてに付与
resource "snowflake_database_grant" "on_database_grant" {
    provider = snowflake.sysadmin
    for_each = local.filtered_map_access_role
    database_name = "SNOWFLAKE_FOR_TF"
    privilege = "USAGE"
    roles = [each.key]
}

# USAGE付与：AccessRoleのすべて
resource "snowflake_schema_grant" "on_schema_grant_read" {
    provider = snowflake.sysadmin
    for_each = {for k,v in local.filtered_map_access_role: k=>v}
    database_name = "SNOWFLAKE_FOR_TF"
    # fix: privilege = "read"
    schema_name   = "SCHEMA_A"
    privilege     = "USAGE"
    roles = [each.key]
    # on_future = true # each.key単位でon_futurを管理しないと、│ "on_future": conflicts with schema_nameが発生する
}

# ロール別にgrant_privilege リソースを作成するのが冗長となる
# yamlでRoleと付与対象のPrivilageを管理できたら楽

# Read付与：AccessRoleの_R, _RW両方
# roleごとに、どのDB,schema, tableに対するPrivilageを付与するか、を外部ファイルで管理するのは楽そう
resource "snowflake_table_grant" "on_table_grant_read" {
    provider = snowflake.sysadmin
    for_each = {for k,v in local.filtered_map_access_role: k=>v}
    database_name = "SNOWFLAKE_FOR_TF"
    schema_name   = "SCHEMA_A"
    privilege     = "SELECT"
    table_name = "T_SNOWFLAKE_FOR_TF"
    roles = [each.key]
}

# ReadWrite付与：AccessRoleの_RWのみ
resource "snowflake_table_grant" "on_table_grant_read_write" {
    provider = snowflake.sysadmin
    for_each = {for k in local.read_write_keys: k=> local.filtered_map_access_role[k]}
    database_name = "SNOWFLAKE_FOR_TF"
    schema_name   = "SCHEMA_A"
    privilege     = "INSERT"
    table_name = "T_SNOWFLAKE_FOR_TF"
    roles = [each.key]
}