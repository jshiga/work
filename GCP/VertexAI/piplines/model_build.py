from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import roc_curve
from sklearn.model_selection import cross_val_predict, train_test_split
from sklearn import datasets, model_selection
import os
import pandas as pd
import pickle
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input-dataset-path')
    parser.add_argument('--output-model-path')
    parser.add_argument('--n-estimators', default=1, type=int)
    args = parser.parse_args()
    
    X = pd.read_pickle(os.path.join(args.input_dataset_path, 'x.pkl'))
    y = pd.read_pickle(os.path.join(args.input_dataset_path, 'y.pkl'))
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=42)
    # build model
    rfc = RandomForestClassifier(
        n_estimators=args.n_estimators 
        , random_state=42
    )
    rfc.fit(X_train, y_train)
    scoring = "accuracy"
    results = model_selection.cross_val_score(rfc, X_train, y_train, cv=3, scoring=scoring)
    acc = ((sum(results)/len(results)) * 100.0)
    print(f"acc: {acc}")    

    os.makedirs(args.output_model_path, exist_ok=True)
    with open(os.path.join(args.output_model_path, 'model.pkl'), "wb") as f:
        pickle.dump(rfc, f)