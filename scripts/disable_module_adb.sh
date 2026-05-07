#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"
start_report "disable-module-adb"

MODULE_ID="${MODULE_ID:-cerberus_mgm_bootanimation}"

echo "Disabling Magisk module with disable flag: $MODULE_ID"
adb_run start-server
adb_run wait-for-device
su_run "if [ -d /data/adb/modules/$MODULE_ID ]; then touch /data/adb/modules/$MODULE_ID/disable; echo disabled; else echo module folder missing; exit 1; fi"

echo
echo "Reboot is required for the disabled state to apply."
echo "Run when ready:"
echo "  adb reboot"
