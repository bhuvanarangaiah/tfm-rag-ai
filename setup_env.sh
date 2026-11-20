#!/usr/bin/env bash
# Crea el entorno virtual e instala dependencias.
# Uso:  bash setup_env.sh            (busca python3.13, python3.12 y luego python3)
#       PYTHON=/ruta/a/python3.12 bash setup_env.sh
set -euo pipefail

is_supported() {
  "$1" -c 'import sys; sys.exit(0 if (3, 12) <= sys.version_info[:2] <= (3, 13) else 1)' 2>/dev/null
}

if [ -z "${PYTHON:-}" ]; then
  # Los alias de zsh no llegan a este script; buscamos en el PATH y en Homebrew.
  for candidate in python3.13 python3.12 /opt/homebrew/bin/python3.13 /opt/homebrew/bin/python3.12 python3; do
    if command -v "$candidate" >/dev/null 2>&1 && is_supported "$candidate"; then
      PYTHON="$candidate"
      break
    fi
  done
fi

if [ -z "${PYTHON:-}" ] || ! is_supported "$PYTHON"; then
  echo "Se requiere Python 3.12 o 3.13 (ver README). Instala uno, p. ej.: brew install python@3.13"
  exit 1
fi

echo "Usando: $($PYTHON --version) ($(command -v "$PYTHON"))"
$PYTHON -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
python -m ipykernel install --user --name tfm-rag-ai --display-name "tfm-rag-ai"
pip freeze > requirements-lock.txt

echo ""
echo "Listo. Activa el entorno con:  source .venv/bin/activate"
echo "Versiones fijadas en requirements-lock.txt (haz commit de este archivo)."
