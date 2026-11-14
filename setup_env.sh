#!/usr/bin/env bash
# Crea el entorno virtual e instala dependencias.
# Uso:  bash setup_env.sh            (usa python3)
#       PYTHON=python3.12 bash setup_env.sh
set -euo pipefail

PYTHON="${PYTHON:-python3}"

echo "Usando: $($PYTHON --version)"
$PYTHON -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
python -m ipykernel install --user --name tfm-rag-ai --display-name "tfm-rag-ai"
pip freeze > requirements-lock.txt

echo ""
echo "Listo. Activa el entorno con:  source .venv/bin/activate"
echo "Versiones fijadas en requirements-lock.txt (haz commit de este archivo)."
