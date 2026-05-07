#!/usr/bin/env bash
set -euo pipefail

GITHUB_URL="${GITHUB_URL:-}"
CODEBERG_URL="${CODEBERG_URL:-}"

git rev-parse --show-toplevel >/dev/null

if [ -z "$GITHUB_URL" ] || [ -z "$CODEBERG_URL" ]; then
  echo "Set both remotes first:"
  echo
  echo "GITHUB_URL=\"git@github.com:USERNAME/cerberus-mgm-boot.git\" \\"
  echo "CODEBERG_URL=\"git@codeberg.org:USERNAME/cerberus-mgm-boot.git\" \\"
  echo "./scripts/add_remotes.sh"
  exit 1
fi

echo "Replacing origin/github/main/codeberg remotes for this repository."
git remote remove origin 2>/dev/null || true
git remote remove github 2>/dev/null || true
git remote remove main 2>/dev/null || true
git remote remove codeberg 2>/dev/null || true

echo "Adding GitHub remote as: main"
git remote add main "$GITHUB_URL"

echo "Adding Codeberg remote as: codeberg"
git remote add codeberg "$CODEBERG_URL"

echo
git remote -v
