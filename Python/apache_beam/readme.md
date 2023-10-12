## 使い方

### 事前準備：ローカルにダミーのaws profileを作る
$ aws configure --profile localstack
    AWS Access Key ID [None]: localstack
    AWS Secret Access Key [None]: localstack
    Default region name [None]: ap-northeast-1
    Default output format [None]: json

### コンテナ起動：docker-composeファイルが存在するディレクトリでコマンド実行
$ docker-compose up -d

### コンテナ起動後：bucketを作る
$ aws s3 mb s3://test-bucket --profile localstack --endpoint-url=http://localhost:4566

### コンテナ起動後：tokenを確認しjupyterコンテナにアクセスする
$ docker logs jupyterコンテナID
>> http://127.0.0.1:8888/lab?token=XXXXXXXX

### 出力ファイルをS3からDL
$ aws s3 cp s3://test-bucket/file/output_filename.txt ./result.txt --profile localstack --endpoint-url=http://localhost:4566