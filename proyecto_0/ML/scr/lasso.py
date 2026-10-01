import numpy as np
import pandas as pd

from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegressionCV
from sklearn.metrics import roc_auc_score


def fit_lasso(
    X_boot,
    y_boot,
    cv=3,
    Cs=None,
    random_state=42
):
    """
    Entrena un modelo LASSO (Logistic Regression L1)
    sobre un único bootstrap.

    Parameters
    ----------
    X_boot : pandas.DataFrame
        Matriz de expresión (muestras x genes)

    y_boot : pandas.DataFrame o pandas.Series
        Variable respuesta binaria

    cv : int
        Número de folds para validación cruzada

    Cs : array-like o None
        Valores de C a evaluar.
        Si es None utiliza una grilla logarítmica.

    random_state : int

    Returns
    -------
    results_df : pandas.DataFrame

    best_C : float

    model : LogisticRegressionCV
    """

    # -----------------------------
    # 1) Grilla de hiperparámetros
    # -----------------------------

    if Cs is None:
        Cs = np.logspace(-3, 3, 20)

    # -----------------------------
    # 2) Escalado
    # -----------------------------

    scaler = StandardScaler()

    X_scaled = scaler.fit_transform(X_boot)

    # -----------------------------
    # 3) Modelo
    # -----------------------------

    model = LogisticRegressionCV(

        penalty="l1",

        solver="liblinear",

        cv=cv,

        scoring="roc_auc",

        Cs=Cs,

        random_state=random_state,

        max_iter=5000

    )

    # -----------------------------
    # 4) Entrenamiento
    # -----------------------------

    model.fit(
        X_scaled,
        y_boot.values.ravel()
    )

    # -----------------------------
    # 5) Extraer resultados
    # -----------------------------

    coef = model.coef_[0]

    best_C = model.C_[0]

    selected = coef != 0

    
    # -----------------------------
    # 6) Evaluar el modelo
    # -----------------------------


    y_prob = model.predict_proba(X_scaled)[:, 1]

    roc_auc = roc_auc_score(
        y_boot.values.ravel(),
        y_prob
    )
    
    # -----------------------------
    # 7) Construir DataFrame
    # -----------------------------

    results_df = pd.DataFrame({

        "gene": X_boot.columns,

        "coefficient": coef,

        "importance": np.abs(coef),

        "selected": selected,

        "bootstrap": None,

        "algorithm": "LASSO"

    })

    return results_df, best_C, roc_auc, model