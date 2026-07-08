#!/usr/bin/env bash

set -Eeuo pipefail

VENV_DIR=".venv"
PYTHON_BIN="${PYTHON_BIN:-python3.12}"
RECREATE=false

log() {
    printf '\033[1;34m[ATOS]\033[0m %s\n' "$1"
}

error() {
    printf '\033[1;31m[ERREUR]\033[0m %s\n' "$1" >&2
}

cleanup_on_error() {
    error "L'installation a échoué à la ligne $1."
}

trap 'cleanup_on_error "$LINENO"' ERR

show_help() {
    cat <<'EOF'
Usage:
  ./setup_venv.sh [--recreate]

Options:
  --recreate   Supprime puis recrée l'environnement virtuel.
  -h, --help   Affiche cette aide.

Variables d'environnement:
  PYTHON_BIN   Interpréteur Python à utiliser.
               Valeur par défaut : python3.12

Exemple:
  PYTHON_BIN=/usr/bin/python3.12 ./setup_venv.sh --recreate
EOF
}

for arg in "$@"; do
    case "$arg" in
        --recreate)
            RECREATE=true
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            error "Argument inconnu : $arg"
            show_help
            exit 1
            ;;
    esac
done

if [[ ! -f "pyproject.toml" ]]; then
    error "Le fichier pyproject.toml est introuvable."
    error "Exécute ce script depuis le dossier backend du projet ATOS."
    exit 1
fi

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
    error "L'interpréteur '$PYTHON_BIN' est introuvable."
    error "Installe Python 3.12 ou définis PYTHON_BIN vers le bon exécutable."
    exit 1
fi

PYTHON_VERSION="$("$PYTHON_BIN" -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
PYTHON_MAJOR="$("$PYTHON_BIN" -c 'import sys; print(sys.version_info.major)')"
PYTHON_MINOR="$("$PYTHON_BIN" -c 'import sys; print(sys.version_info.minor)')"

log "Interpréteur détecté : $PYTHON_BIN ($PYTHON_VERSION)"

if (( PYTHON_MAJOR < 3 || (PYTHON_MAJOR == 3 && PYTHON_MINOR < 12) )); then
    error "Python 3.12 minimum est requis. Version détectée : $PYTHON_VERSION"
    exit 1
fi

if [[ "$RECREATE" == true && -d "$VENV_DIR" ]]; then
    log "Suppression de l'environnement virtuel existant..."
    rm -rf "$VENV_DIR"
fi

if [[ ! -d "$VENV_DIR" ]]; then
    log "Création de l'environnement virtuel dans $VENV_DIR..."
    "$PYTHON_BIN" -m venv "$VENV_DIR"
else
    log "L'environnement virtuel $VENV_DIR existe déjà."
fi

VENV_PYTHON="$VENV_DIR/bin/python"

if [[ ! -x "$VENV_PYTHON" ]]; then
    error "L'exécutable Python du venv est introuvable : $VENV_PYTHON"
    exit 1
fi

log "Mise à jour de pip, setuptools et wheel..."
"$VENV_PYTHON" -m pip install --upgrade pip setuptools wheel

log "Installation d'ATOS et des dépendances de développement..."
"$VENV_PYTHON" -m pip install -e ".[dev]"

log "Vérification des dépendances principales..."
"$VENV_PYTHON" -c '
import fastapi
import pydantic_settings
import uvicorn

print("FastAPI :", fastapi.__version__)
print("Pydantic Settings :", pydantic_settings.__version__)
print("Uvicorn :", uvicorn.__version__)
'

printf '\n'
log "Installation terminée avec succès."
printf 'Active le venv avec :\n\n'
printf '  source %s/bin/activate\n\n' "$VENV_DIR"
printf 'Puis démarre l’API avec :\n\n'
printf '  python -m uvicorn atos_api.main:app --reload\n\n'
