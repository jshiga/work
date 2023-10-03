# dockerコンテナ起動
docker-compose run --rm server create_db
docker-compose up -d

# ディレクトリ構造
home
|_ initdb
|	 |_ init_sql.sql
|_ docker-compose.yml
|_ redash.env


# 元になっているソース
https://github.com/GitSumito/redash-v7.git
