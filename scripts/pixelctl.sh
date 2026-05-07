#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"

cmd="${1:-help}"
shift || true

case "$cmd" in
  help)
    cat <<HELP
pixelctl.sh commands:

  health                    Root/device/module healthcheck
  reboot                    Reboot phone and wait for boot completion
  systemui                  Restart SystemUI
  logs                      Pull recent boot/Magisk/SystemUI logs
  modules                   List Magisk modules
  module-check MODULE_ID     Check one module
  module-disable MODULE_ID   Touch module disable flag
  module-enable MODULE_ID    Remove module disable flag
  bootanim-check            Check Cerberus MGM boot module
  bootanim-disable          Disable Cerberus MGM boot module
  bootanim-enable           Enable Cerberus MGM boot module
  screenshot                Save screenshot under reports/
  screenrecord-start        Print a safe manual screenrecord command
  screenrecord-stop         Stop screenrecord process on phone
  install-apk APK           Install an APK through adb
  open-url URL              Open URL on phone
  launch PACKAGE            Launch package with monkey
  wake                      Wake screen
  lock                      Lock screen
  pull-report PHONE_PATH    Pull a phone file into reports/

Examples:
  ./scripts/pixelctl.sh health
  ./scripts/pixelctl.sh bootanim-check
  ./scripts/pixelctl.sh module-disable PixelXpert
HELP
    ;;

  health)
    start_report "pixelctl-health"
    echo "=== Device ==="
    adb_run start-server
    adb_run wait-for-device
    adb_run shell getprop ro.product.model || true
    adb_run shell getprop ro.product.device || true
    adb_run shell getprop ro.build.version.release || true
    adb_run shell getprop sys.boot_completed || true
    echo
    echo "=== Root ==="
    su_run id || true
    echo
    echo "=== Modules ==="
    su_run "ls -1 /data/adb/modules 2>/dev/null || true"
    ;;

  reboot)
    start_report "pixelctl-reboot"
    echo "Rebooting phone, then waiting for boot completion."
    adb_run reboot
    adb_run wait-for-device
    until [ "$(adb_run shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
      sleep 2
      echo "Still booting..."
    done
    echo "Boot complete."
    su_run id || true
    ;;

  systemui)
    start_report "pixelctl-systemui"
    echo "Restarting SystemUI."
    su_run "pkill -f com.android.systemui" || true
    sleep 5
    su_run "ps -A | grep -Ei 'systemui|zygisk|lspd|pixelxpert' || true"
    ;;

  logs)
    start_report "pixelctl-logs"
    adb_run shell logcat -d -t 1000 | grep -Ei "bootanim|Magisk|SystemUI|PixelXpert|siava|AOSPMods|LSPosed|lspd|Vector|zygisk|AndroidRuntime|FATAL" | tail -n 220 || true
    ;;

  modules)
    start_report "pixelctl-modules"
    su_run "for d in /data/adb/modules/*; do [ -d \"\$d\" ] || continue; echo === \$(basename \"\$d\") ===; cat \"\$d/module.prop\" 2>/dev/null || true; [ -e \"\$d/disable\" ] && echo flag:disable || true; done"
    ;;

  module-check)
    start_report "pixelctl-module-check"
    module="${1:?Usage: ./scripts/pixelctl.sh module-check MODULE_ID}"
    su_run "for d in /data/adb/modules/$module /data/adb/modules_update/$module; do echo === \$d ===; if [ -d \"\$d\" ]; then ls -la \"\$d\"; cat \"\$d/module.prop\" 2>/dev/null || true; else echo missing; fi; done"
    ;;

  module-disable)
    start_report "pixelctl-module-disable"
    module="${1:?Usage: ./scripts/pixelctl.sh module-disable MODULE_ID}"
    su_run "test -d /data/adb/modules/$module && touch /data/adb/modules/$module/disable"
    echo "Disabled $module with a Magisk disable flag. Reboot when ready."
    ;;

  module-enable)
    start_report "pixelctl-module-enable"
    module="${1:?Usage: ./scripts/pixelctl.sh module-enable MODULE_ID}"
    su_run "test -d /data/adb/modules/$module && rm -f /data/adb/modules/$module/disable"
    echo "Enabled $module by removing the disable flag. Reboot when ready."
    ;;

  bootanim-check)
    MODULE_ID=cerberus_mgm_bootanimation "$SCRIPT_DIR/verify_module_adb.sh"
    ;;

  bootanim-disable)
    MODULE_ID=cerberus_mgm_bootanimation "$SCRIPT_DIR/disable_module_adb.sh"
    ;;

  bootanim-enable)
    MODULE_ID=cerberus_mgm_bootanimation "$SCRIPT_DIR/enable_module_adb.sh"
    ;;

  screenshot)
    start_report "pixelctl-screenshot"
    out="$REPO_DIR/reports/screenshot-$(timestamp).png"
    phone="/sdcard/Download/cerberus-screenshot.png"
    adb_run shell screencap -p "$phone"
    adb_run pull "$phone" "$out"
    echo "Screenshot: $out"
    ;;

  screenrecord-start)
    start_report "pixelctl-screenrecord-start"
    echo "Run this in a dedicated terminal because screenrecord stays attached until stopped:"
    echo "nix-shell -p android-tools --run 'adb shell screenrecord /sdcard/Movies/cerberus-screenrecord.mp4'"
    ;;

  screenrecord-stop)
    start_report "pixelctl-screenrecord-stop"
    adb_run shell pkill -INT screenrecord || true
    echo "Stopped screenrecord if it was running."
    ;;

  install-apk)
    start_report "pixelctl-install-apk"
    apk="${1:?Usage: ./scripts/pixelctl.sh install-apk APK}"
    adb_run install "$apk"
    ;;

  open-url)
    start_report "pixelctl-open-url"
    url="${1:?Usage: ./scripts/pixelctl.sh open-url URL}"
    adb_run shell am start -a android.intent.action.VIEW -d "$url"
    ;;

  launch)
    start_report "pixelctl-launch"
    package="${1:?Usage: ./scripts/pixelctl.sh launch PACKAGE}"
    adb_run shell monkey -p "$package" 1
    ;;

  wake)
    start_report "pixelctl-wake"
    adb_run shell input keyevent KEYCODE_WAKEUP
    ;;

  lock)
    start_report "pixelctl-lock"
    adb_run shell input keyevent KEYCODE_SLEEP
    ;;

  pull-report)
    start_report "pixelctl-pull-report"
    phone_path="${1:?Usage: ./scripts/pixelctl.sh pull-report PHONE_PATH}"
    adb_run pull "$phone_path" "$REPO_DIR/reports/"
    ;;

  *)
    echo "Unknown command: $cmd"
    echo "Run: ./scripts/pixelctl.sh help"
    exit 1
    ;;
esac
