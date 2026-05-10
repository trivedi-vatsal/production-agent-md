#!/usr/bin/env bash
#
# Install CLAUDE.md into the current repo/folder by default.
# Mirror the same content to AGENTS.md for Codex and seed starter
# session-artifact files from templates/.
#
# Usage:
#   install.sh             # current directory (default)
#   install.sh project     # explicit current directory
#   install.sh personal    # optional global ~/.claude install
#
# Override the source repo with CLAUDE_MD_REPO_RAW.

set -euo pipefail

REPO_RAW="${CLAUDE_MD_REPO_RAW:-https://raw.githubusercontent.com/trivedi-vatsal/production-agent-md/main}"
SCOPE="${1:-project}"

case "$SCOPE" in
  personal)
    TARGET_DIR="$HOME/.claude"
    ;;
  project)
    TARGET_DIR="$(pwd)"
    ;;
  *)
    echo "error: unknown scope '$SCOPE'" >&2
    echo "usage: install.sh [personal|project]" >&2
    exit 1
    ;;
esac

if ! command -v curl >/dev/null 2>&1; then
  echo "error: curl is required but not installed" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

download_file() {
  local remote_path="$1"
  local local_path="$2"

  if ! curl -fsSL "$REPO_RAW/$remote_path" -o "$local_path"; then
    echo "error: failed to download $remote_path from $REPO_RAW" >&2
    exit 1
  fi
}

install_file() {
  local source="$1"
  local target="$2"
  local label="$3"

  if [ -f "$target" ]; then
    local backup="${target}.backup.${TIMESTAMP}"
    cp "$target" "$backup"
    echo "backed up existing ${label} -> $backup"
  fi

  cp "$source" "$target"
  echo "installed ${label} -> $target"
}

install_if_missing() {
  local source="$1"
  local target="$2"
  local label="$3"

  if [ -f "$target" ]; then
    echo "kept existing ${label} -> $target"
    return
  fi

  cp "$source" "$target"
  echo "installed ${label} -> $target"
}

download_file "CLAUDE.md" "$TMP_DIR/CLAUDE.md"
install_file "$TMP_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md" "CLAUDE.md"

if [ "$SCOPE" = "project" ]; then
  install_file "$TMP_DIR/CLAUDE.md" "$TARGET_DIR/AGENTS.md" "AGENTS.md"
  download_file "templates/gotchas.md" "$TMP_DIR/gotchas.md"
  download_file "templates/context-log.md" "$TMP_DIR/context-log.md"
  install_if_missing "$TMP_DIR/gotchas.md" "$TARGET_DIR/gotchas.md" "gotchas.md"
  install_if_missing "$TMP_DIR/context-log.md" "$TARGET_DIR/context-log.md" "context-log.md"
fi

echo "completed install for $SCOPE scope"
