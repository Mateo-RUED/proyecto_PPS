from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import roc_auc_score
import pandas as pd


def fit_random_forest(
    X_boot,
    y_boot,
    n_estimators=500,
    random_state=42
):
    """
    Entrena un Random Forest sobre un bootstrap.

    Parámetros
    ----------
    X_boot : DataFrame
        Matriz de expresión (muestras x genes).

    y_boot : Series o DataFrame
        Variable respuesta K1 (0/1).

    n_estimators : int
        Número de árboles del Random Forest.

    random_state : int
        Semilla para reproducibilidad.

    Retorna
    -------
    results_df : DataFrame
        Importancia de cada gen.

    roc_auc : float
        ROC-AUC del modelo sobre el bootstrap.

    model : RandomForestClassifier
        Modelo entrenado.
    """

    # Asegurar que y sea un vector 1D
    y = y_boot.values.ravel()

    # Crear modelo
    model = RandomForestClassifier(
        n_estimators=n_estimators,
        random_state=random_state,
        n_jobs=-1
    )

    # Entrenar
    model.fit(X_boot, y)

    # --------------------------------
    # Importancia de los genes
    # --------------------------------

    importance = model.feature_importances_

    results_df = pd.DataFrame({
        "gene": X_boot.columns,
        "importance": importance
    })

    # --------------------------------
    # ROC-AUC
    # --------------------------------

    y_prob = model.predict_proba(X_boot)[:, 1]

    roc_auc = roc_auc_score(
        y,
        y_prob
    )

    return results_df, roc_auc, model