#!/usr/bin/env bash
set -euo pipefail

OUT="readme_manifest.md"

{
  echo "# Repository Manifest"
  echo
  echo "Generated: $(date -Is)"
  echo
  echo "## Files"
  echo
  find . \
    -path ./.git -prune -o \
    -path ./reports -prune -o \
    -name "$OUT" -prune -o \
    -type f -print | sort | while read -r file; do
    sha="$(sha256sum "$file" | awk "{print \$1}")"
    size="$(stat -c "%s" "$file")"
    echo "- \`${file#./}\`"
    echo "  - size: $size bytes"
    echo "  - sha256: \`$sha\`"
  done
} > "$OUT"

echo "Wrote $OUT"
