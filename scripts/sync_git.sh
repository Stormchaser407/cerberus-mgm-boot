#!/usr/bin/env bash
set -euo pipefail

BRANCH="$(git branch --show-current)"
[ -n "$BRANCH" ] || BRANCH="main"
configured=0
failed=0

echo "=== Git status ==="
git status --short
echo
echo "Current branch: $BRANCH"

echo
echo "=== Push GitHub/main ==="
if git remote get-url main >/dev/null 2>&1; then
  configured=$((configured + 1))
  if git push -u main "$BRANCH"; then
    echo "GitHub/main push succeeded."
  else
    echo "GitHub/main push failed."
    failed=$((failed + 1))
  fi
else
  echo "No main remote configured for GitHub."
fi

echo
echo "=== Push Codeberg/codeberg ==="
if git remote get-url codeberg >/dev/null 2>&1; then
  configured=$((configured + 1))
  if git push -u codeberg "$BRANCH"; then
    echo "Codeberg/codeberg push succeeded."
  else
    echo "Codeberg/codeberg push failed."
    failed=$((failed + 1))
  fi
else
  echo "No codeberg remote configured."
fi

echo
if [ "$configured" -eq 0 ]; then
  echo "No GitHub/main or Codeberg/codeberg remotes are configured."
  echo "Add them with:"
  echo
  echo "GITHUB_URL=\"git@github.com:USERNAME/cerberus-mgm-boot.git\" \\"
  echo "CODEBERG_URL=\"git@codeberg.org:USERNAME/cerberus-mgm-boot.git\" \\"
  echo "./scripts/add_remotes.sh"
  exit 1
fi

if [ "$failed" -gt 0 ]; then
  echo "$failed configured remote push failed. Check the messages above, fix the remote or credentials, then rerun ./scripts/sync_git.sh."
  exit 1
fi

echo "All configured mirror pushes succeeded."
