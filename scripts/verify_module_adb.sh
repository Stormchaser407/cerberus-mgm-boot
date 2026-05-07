#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"
start_report "verify-module-adb"

MODULE_ID="${MODULE_ID:-cerberus_mgm_bootanimation}"

echo "Verifying Magisk module staging for: $MODULE_ID"
adb_run start-server
adb_run wait-for-device

su_run "for d in /data/adb/modules/$MODULE_ID /data/adb/modules_update/$MODULE_ID; do
  echo === \$d ===
  if [ -d \"\$d\" ]; then
    ls -la \"\$d\"
    echo
    echo module.prop:
    cat \"\$d/module.prop\" 2>/dev/null || echo missing
    echo
    for f in disable update remove; do
      if [ -e \"\$d/\$f\" ]; then echo \"flag: \$f present\"; else echo \"flag: \$f absent\"; fi
    done
    echo
    for p in system/media/bootanimation.zip system/product/media/bootanimation.zip; do
      if [ -f \"\$d/\$p\" ]; then
        ls -lh \"\$d/\$p\"
        sha256sum \"\$d/\$p\" 2>/dev/null || true
      else
        echo \"missing: \$d/\$p\"
      fi
    done
  else
    echo missing
  fi
done"
