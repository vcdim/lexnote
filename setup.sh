#!/usr/bin/env bash
set -euo pipefail

STY_FILE="lexnote.sty"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="${SCRIPT_DIR}/${STY_FILE}"

if [ ! -f "$SRC" ]; then
  echo "Error: ${SRC} not found"
  exit 1
fi

# Detect TEXMFHOME (works on macOS, Linux, Windows/MSYS)
TEXMFHOME="$(kpsewhich -var-value TEXMFHOME)"
DEST_DIR="${TEXMFHOME}/tex/latex/lexnote"

mkdir -p "$DEST_DIR"
cp "$SRC" "$DEST_DIR/"

echo "Installed ${STY_FILE} -> ${DEST_DIR}/${STY_FILE}"
