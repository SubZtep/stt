#!/usr/bin/env bash
# Install stt: download the scripts into ~/.local/bin (override with PREFIX).
#   curl -fsSL https://raw.githubusercontent.com/SubZtep/stt/main/install.sh | bash
set -euo pipefail

REPO="${STT_REPO:-SubZtep/stt}"
REF="${STT_REF:-main}"
BASE="https://raw.githubusercontent.com/$REPO/$REF"
BIN_DIR="${PREFIX:-$HOME/.local}/bin"

# required to run the installer + the tool itself
command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }

echo "Installing stt -> $BIN_DIR"
mkdir -p "$BIN_DIR"
for f in stt stt-layout-lang; do
  curl -fsSL "$BASE/$f" -o "$BIN_DIR/$f"
  chmod +x "$BIN_DIR/$f"
  echo "  $f"
done

# soft dependency check (warn only)
command -v ffmpeg >/dev/null || echo "WARNING: ffmpeg not found — stt needs it to record." >&2
echo "Optional: wl-clipboard + libnotify (keybind), jq + hyprctl (stt-layout-lang)."

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "NOTE: $BIN_DIR is not on PATH — add it to your shell profile." ;;
esac

echo "Done. Try: stt   (speak, Ctrl-C to stop)"
