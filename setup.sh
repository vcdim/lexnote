#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect TEXMFHOME (works on macOS, Linux, Windows/MSYS)
TEXMFHOME="$(kpsewhich -var-value TEXMFHOME)"
DEST_DIR="${TEXMFHOME}/tex/latex/lexnote"

mkdir -p "$DEST_DIR"

cp "${SCRIPT_DIR}/lexnote.cls" "$DEST_DIR/"
echo "Installed lexnote.cls -> ${DEST_DIR}/lexnote.cls"
