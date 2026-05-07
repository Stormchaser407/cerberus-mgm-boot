#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/mnt/storage/Cole/Projects/cerberus-mgm-boot"
VAULT_DIR="/mnt/storage/Cole/main_vault/Projects/Cerberus MGM Boot"

mkdir -p "$VAULT_DIR"

cp "$REPO_DIR/docs/obsidian_index.md" "$VAULT_DIR/index.md"
cp "$REPO_DIR/docs/concept.md" "$VAULT_DIR/concept.md"
cp "$REPO_DIR/docs/frame_plan.md" "$VAULT_DIR/frame_plan.md"
cp "$REPO_DIR/docs/prompt_bank.md" "$VAULT_DIR/prompt_bank.md"
cp "$REPO_DIR/docs/bootanimation_structure.md" "$VAULT_DIR/bootanimation_structure.md"
cp "$REPO_DIR/docs/production_notes.md" "$VAULT_DIR/production_notes.md"
cp "$REPO_DIR/docs/repo_sync_runbook.md" "$VAULT_DIR/repo_sync_runbook.md"
cp "$REPO_DIR/README.md" "$VAULT_DIR/README.md"

cat > "$VAULT_DIR/_sync_status.md" <<STATUS
---
type: sync-status
project: Cerberus MGM Boot
updated: $(date -Is)
---

# Sync Status

Synced from:

    $REPO_DIR

To:

    $VAULT_DIR
STATUS

echo "Synced docs to Obsidian: $VAULT_DIR"
