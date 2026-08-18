import pandas as pd


y = pd.read_csv(
    "labels_K1.csv"
)

y.head()

y = y.set_index("sample")

X.index.equals(y.index)

X_model = X.copy()

y_model = y["K1"]

from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import StratifiedKFold, cross_val_score

lasso = Pipeline([

    ("scale", StandardScaler()),

    ("model",
     LogisticRegression(
        penalty="l1",
        solver="liblinear",
        C=0.1,
        max_iter=5000
     ))

])
