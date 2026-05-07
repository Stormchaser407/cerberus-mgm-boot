#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"
start_report "reboot-and-check-adb"

MODULE_ID="${MODULE_ID:-cerberus_mgm_bootanimation}"

echo "This script will reboot the connected device, wait for boot completion, then check root and module state."
echo "Module ID: $MODULE_ID"
echo

adb_run start-server
adb_run wait-for-device
adb_run reboot

echo "Waiting for device..."
adb_run wait-for-device

echo "Waiting for sys.boot_completed=1..."
until [ "$(adb_run shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
  sleep 2
  echo "Still booting..."
done

sleep 5

echo
echo "=== Root ==="
su_run id || true

echo
echo "=== Module state ==="
su_run "for d in /data/adb/modules/$MODULE_ID /data/adb/modules_update/$MODULE_ID; do
  echo === \$d ===
  if [ -d \"\$d\" ]; then
    cat \"\$d/module.prop\" 2>/dev/null || true
    for f in disable update remove; do
      if [ -e \"\$d/\$f\" ]; then echo \"flag: \$f present\"; else echo \"flag: \$f absent\"; fi
    done
    ls -lh \"\$d/system/media/bootanimation.zip\" \"\$d/system/product/media/bootanimation.zip\" 2>/dev/null || true
  else
    echo missing
  fi
done"

echo
echo "=== Recent boot/module log hints ==="
adb_run shell logcat -d -t 600 | grep -Ei "bootanim|Magisk|cerberus|zygisk|lspd|AndroidRuntime|FATAL" | tail -n 160 || true
