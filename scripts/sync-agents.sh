#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cp "$REPO_ROOT/CLAUDE.md" "$REPO_ROOT/AGENTS.md"
echo "synced AGENTS.md from CLAUDE.md"
