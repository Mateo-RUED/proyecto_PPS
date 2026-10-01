from sklearn.svm import SVC
from sklearn.feature_selection import RFE
from sklearn.metrics import roc_auc_score
from sklearn.model_selection import StratifiedKFold, cross_val_score
import pandas as pd


def fit_svm_rfe(
    X_boot,
    y_boot,
    n_features_to_select=10,
    random_state=42
):
  	
    """
    Entrena un SVM lineal utilizando Recursive Feature Elimination (RFE).

    Parámetros
    ----------
    X_boot : DataFrame
        Matriz de expresión.

    y_boot : Series o DataFrame
        Variable respuesta (K1).

    n_features_to_select : int
        Número de genes que RFE conservará.

    random_state : int

    Retorna
    -------
    results_df
    roc_auc
    model
    """

    # Vector respuesta
    y = y_boot.values.ravel()

    # SVM lineal
    svc = SVC(
        kernel="linear",
        probability=True,
        random_state=random_state
    )

    # RFE
    selector = RFE(
        estimator=svc,
        n_features_to_select=n_features_to_select
    )

    selector.fit(X_boot, y)

    # Probabilidades
    y_prob = selector.predict_proba(X_boot)[:, 1]

    roc_auc = roc_auc_score(
        y,
        y_prob
    )

    # DataFrame de resultados
    results_df = pd.DataFrame({

        "gene": X_boot.columns,

        "ranking": selector.ranking_,

        "selected": selector.support_

    })

    

    return results_df, roc_auc, selector
