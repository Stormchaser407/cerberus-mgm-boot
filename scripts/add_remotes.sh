#!/usr/bin/env bash
set -euo pipefail

GITHUB_URL="${GITHUB_URL:-}"
CODEBERG_URL="${CODEBERG_URL:-}"

if [ -z "$GITHUB_URL" ] || [ -z "$CODEBERG_URL" ]; then
  echo "Set both remotes first:"
  echo
  echo "GITHUB_URL=\"git@github.com:USERNAME/cerberus-mgm-boot.git\" \\"
  echo "CODEBERG_URL=\"git@codeberg.org:USERNAME/cerberus-mgm-boot.git\" \\"
  echo "./scripts/add_remotes.sh"
  exit 1
fi

git remote remove github 2>/dev/null || true
git remote remove codeberg 2>/dev/null || true
git remote remove origin 2>/dev/null || true

git remote add github "$GITHUB_URL"
git remote add codeberg "$CODEBERG_URL"

git remote -v
