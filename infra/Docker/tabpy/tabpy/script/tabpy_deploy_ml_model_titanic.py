import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
import tabpy_client

# tabpy client
client = tabpy_client.Client('http://127.0.0.1:9004/') 

def survived_prediction_model(_arg1,_arg2,_arg3,_arg4,_arg5) -> list:
    # 引数をDataFrameに格納
    df_titanic = pd.DataFrame(
        {
            "survived":_arg1
            , "sex": _arg2
            , "age":_arg3
            , "fare":_arg4
            , "table_nm":_arg5         
        }
    )

    # 学習用データとテストデータに分割
    train = df_titanic[df_titanic["table_nm"]=="train.csv"]
    test = df_titanic[df_titanic["table_nm"]=="test.csv"]

    # 欠損値補完
    inpute_age = train["age"].median()
    inpute_fare = train["fare"].median()
    train["age"].fillna(inpute_age, inplace=True)
    train["fare"].fillna(inpute_fare, inplace=True)
    test["age"].fillna(inpute_age, inplace=True)
    test["fare"].fillna(inpute_fare, inplace=True)

    # ダミー変換(sex)
    train = pd.get_dummies(train, drop_first=True, columns=["sex"])
    test = pd.get_dummies(test, drop_first=True, columns=["sex"])

    # ターゲット変数
    train_X = train.drop(["survived","table_nm"], axis=1)
    train_y = train["survived"]
    test_X = test.drop(["survived","table_nm"], axis=1)
    # Tableua側でモデル出力結果の正誤判定を行うため予測時には学習用特徴量を利用する
    X = pd.concat([train_X], axis=0)

    # 学習
    LR = LogisticRegression()
    LR.fit(train_X, train_y)
    rs = LR.predict(X)
    return rs.tolist()

# 関数のデプロイ
client.deploy(
    'survived_prediction_model'
    , survived_prediction_model
    , 'LogisticRegression'
    , override=True
)