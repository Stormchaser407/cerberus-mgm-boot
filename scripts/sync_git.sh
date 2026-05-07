#!/usr/bin/env bash
set -euo pipefail

BRANCH="$(git branch --show-current)"
[ -n "$BRANCH" ] || BRANCH="main"

echo "=== Git status ==="
git status --short

echo
echo "=== Push GitHub ==="
if git remote get-url github >/dev/null 2>&1; then
  git push -u github "$BRANCH"
else
  echo "No github remote configured."
fi

echo
echo "=== Push Codeberg ==="
if git remote get-url codeberg >/dev/null 2>&1; then
  git push -u codeberg "$BRANCH"
else
  echo "No codeberg remote configured."
fi
