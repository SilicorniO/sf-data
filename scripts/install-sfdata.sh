#!/usr/bin/env bash
# Copy the sf-data binary to ~/.local/bin/sfdata and add that folder to PATH.
# Usage: ./scripts/install-sfdata.sh [path-to-binary]
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
given=${1:-}

case "$(uname -s)" in
  Darwin)
    if [ "$(uname -m)" != "arm64" ]; then
      echo "Apple Silicon is required. This Mac is $(uname -m)." >&2
      exit 1
    fi
    binary_name="sf-data-macos-arm64"
    if [ "$(basename "${SHELL:-}")" = "bash" ]; then
      rc_file="$HOME/.bash_profile"
    else
      rc_file="$HOME/.zshrc"
    fi
    ;;
  Linux)
    binary_name="sf-data-linux-x64"
    rc_file="$HOME/.bashrc"
    ;;
  *)
    echo "Unsupported system: $(uname -s). On Windows run install-sfdata.ps1." >&2
    exit 1
    ;;
esac

if [ -n "$given" ]; then
  if [ ! -f "$given" ]; then
    echo "Binary not found: $given" >&2
    exit 1
  fi
  binary=$given
elif [ -f "$script_dir/$binary_name" ]; then
  binary="$script_dir/$binary_name"
elif [ -f "$script_dir/../dist-exec/$binary_name" ]; then
  binary="$script_dir/../dist-exec/$binary_name"
else
  echo "Binary not found. Pass its path, place $binary_name next to this script, or run npm run build:executables." >&2
  exit 1
fi

mkdir -p "$HOME/.local/bin"
cp -f "$binary" "$HOME/.local/bin/sfdata"
chmod +x "$HOME/.local/bin/sfdata"

if [ "$(uname -s)" = "Darwin" ]; then
  xattr -d com.apple.quarantine "$HOME/.local/bin/sfdata" 2>/dev/null || true
fi

path_line='export PATH="$HOME/.local/bin:$PATH"'
if [ ! -f "$rc_file" ] || ! grep -q '\.local/bin' "$rc_file"; then
  if [ -s "$rc_file" ]; then
    printf '\n%s\n' "$path_line" >> "$rc_file"
  else
    printf '%s\n' "$path_line" >> "$rc_file"
  fi
fi

echo "Installed ~/.local/bin/sfdata. Open a new terminal and run: sfdata --help"
