#!/usr/bin/env bash
# Install agent role cards into an agent-host custom-agents directory.
#
# Usage:
#   ./install-agents.sh <source-dir> <destination-dir> [copy|symlink]
#
# Example:
#   ./install-agents.sh ../agents /path/to/host/agents
#   ./install-agents.sh ../agents /path/to/host/agents symlink

set -euo pipefail

usage() {
    echo "Usage: $0 <source-dir> <destination-dir> [copy|symlink]" >&2
    exit 1
}

SOURCE="${1:-}"
DESTINATION="${2:-}"
MODE="${3:-copy}"

[[ -n "$SOURCE" && -n "$DESTINATION" ]] || usage

if [[ "$MODE" != "copy" && "$MODE" != "symlink" ]]; then
    echo "Mode must be 'copy' or 'symlink', got: $MODE" >&2
    exit 1
fi

if [[ ! -d "$SOURCE" ]]; then
    echo "Source directory does not exist: $SOURCE" >&2
    exit 1
fi

SOURCE="$(cd "$SOURCE" && pwd)"
mkdir -p "$DESTINATION"
DESTINATION="$(cd "$DESTINATION" && pwd)"

shopt -s nullglob
agent_files=("$SOURCE"/*.md)
shopt -u nullglob

if [[ ${#agent_files[@]} -eq 0 ]]; then
    echo "No agent files (*.md) found in: $SOURCE" >&2
    exit 1
fi

for agent_file in "${agent_files[@]}"; do
    name="$(basename "$agent_file")"
    target="$DESTINATION/$name"

    rm -f "$target"

    if [[ "$MODE" == "symlink" ]]; then
        ln -s "$agent_file" "$target"
        echo "Linked $name"
    else
        cp "$agent_file" "$target"
        echo "Copied $name"
    fi
done

echo "Installed ${#agent_files[@]} agent(s) from $SOURCE to $DESTINATION ($MODE)."
