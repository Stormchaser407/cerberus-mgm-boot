#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"
start_report "install-module-adb"

MODULE_ZIP="${MODULE_ZIP:-}"
if [ -z "$MODULE_ZIP" ]; then
  MODULE_ZIP="$(latest_file "$REPO_DIR/downloads/cerberus_mgm_bootanimation-*.zip" || true)"
fi

if [ -z "$MODULE_ZIP" ] || [ ! -f "$MODULE_ZIP" ]; then
  echo "No generated module ZIP found."
  echo "Build and package first:"
  echo "  ./scripts/build_bootanimation_zip.sh"
  echo "  ./scripts/package_magisk_module.sh"
  exit 1
fi

BASENAME="$(basename "$MODULE_ZIP")"
PHONE_ZIP="/sdcard/Download/$BASENAME"
REBOOT_AFTER=0
if [ "${1:-}" = "--reboot" ]; then
  REBOOT_AFTER=1
fi

echo "Installing Magisk module through ADB."
echo "Local ZIP: $MODULE_ZIP"
echo "Phone ZIP: $PHONE_ZIP"
echo "Auto-reboot: $REBOOT_AFTER"
echo

adb_run start-server
adb_run wait-for-device
adb_run push "$MODULE_ZIP" "$PHONE_ZIP"
su_run "magisk --install-module '$PHONE_ZIP'"

echo
echo "Install command finished."
if [ "$REBOOT_AFTER" -eq 1 ]; then
  echo "Reboot flag passed. Rebooting now."
  adb_run reboot
else
  echo "No reboot performed. Reboot manually when ready:"
  echo "  adb reboot"
fi
