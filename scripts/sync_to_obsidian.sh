#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/mnt/storage/Cole/Projects/cerberus-mgm-boot"
VAULT_DIR="/mnt/storage/Cole/main_vault/Projects/Cerberus MGM Boot"

mkdir -p "$VAULT_DIR"

copy_doc() {
  local source="$1"
  local dest="$2"
  echo "Copying doc: $source -> $dest"
  cp "$REPO_DIR/$source" "$VAULT_DIR/$dest"
}

echo "Syncing documentation only to Obsidian."
copy_doc "docs/obsidian_index.md" "index.md"
copy_doc "docs/concept.md" "concept.md"
copy_doc "docs/frame_plan.md" "frame_plan.md"
copy_doc "docs/prompt_bank.md" "prompt_bank.md"
copy_doc "docs/bootanimation_structure.md" "bootanimation_structure.md"
copy_doc "docs/production_notes.md" "production_notes.md"
copy_doc "docs/project_scope.md" "project_scope.md"
copy_doc "docs/current_device_state.md" "current_device_state.md"
copy_doc "docs/repo_sync_runbook.md" "repo_sync_runbook.md"
copy_doc "docs/adb_terminal_workflow.md" "adb_terminal_workflow.md"
copy_doc "docs/magisk_bootanimation_module.md" "magisk_bootanimation_module.md"
copy_doc "docs/tasker_macrodroid_plan.md" "tasker_macrodroid_plan.md"
copy_doc "README.md" "README.md"

cat > "$VAULT_DIR/_sync_status.md" <<STATUS
---
project: Cerberus MGM Boot
type: sync-status
status: active
tags:
  - cerberus
  - obsidian
  - sync
updated: $(date -Is)
---

# Sync Status

Synced documentation from:

\`\`\`text
$REPO_DIR
\`\`\`

To:

\`\`\`text
$VAULT_DIR
\`\`\`

Only curated Markdown documentation and README.md are copied. Scripts, reports, assets, generated frames, ZIP files, binaries, downloads, and Git internals are not part of the Obsidian sync.
STATUS

echo "Synced docs to Obsidian: $VAULT_DIR"
