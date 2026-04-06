#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect TEXMFHOME (works on macOS, Linux, Windows/MSYS)
TEXMFHOME="$(kpsewhich -var-value TEXMFHOME)"
DEST_DIR="${TEXMFHOME}/tex/latex/lexnote"

mkdir -p "$DEST_DIR"

cp "${SCRIPT_DIR}/lexnote.cls" "$DEST_DIR/"
echo "Installed lexnote.cls -> ${DEST_DIR}/lexnote.cls"

# Install Calibri font (macOS) if not present
if [[ "$(uname)" == "Darwin" ]]; then
  FONT_PATH="$HOME/Library/Fonts/calibri.ttf"
  if [[ ! -f "$FONT_PATH" ]]; then
    echo "Installing Calibri font..."
    curl -fsSL "https://github.com/jondot/dotfiles/blob/master/.fonts/calibri.ttf?raw=true" -o "$FONT_PATH"
    echo "Installed Calibri -> $FONT_PATH"
  else
    echo "Calibri font already installed, skipping."
  fi
fi
