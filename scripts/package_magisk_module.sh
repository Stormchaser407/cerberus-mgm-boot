#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"
start_report "package-magisk-module"

MODULE_ID="cerberus_mgm_bootanimation"
VERSION="${MODULE_VERSION:-0.1-pipeline}"
VERSION_CODE="${MODULE_VERSION_CODE:-1}"
BOOT_ZIP="${BOOT_ZIP:-$REPO_DIR/bootanimation/bootanimation.zip}"
STAGE="$REPO_DIR/build/$MODULE_ID"
OUT_DIR="$REPO_DIR/downloads"
OUT_ZIP="$OUT_DIR/${MODULE_ID}-$(timestamp).zip"

echo "Packaging Magisk boot animation module"
echo "Module ID: $MODULE_ID"
echo "Bootanimation ZIP: $BOOT_ZIP"

if [ ! -f "$BOOT_ZIP" ]; then
  echo "Missing $BOOT_ZIP"
  echo "Build it first with: ./scripts/build_bootanimation_zip.sh"
  exit 1
fi

rm -rf "$STAGE"
mkdir -p "$STAGE/system/media" "$STAGE/system/product/media" "$STAGE/META-INF/com/google/android" "$OUT_DIR"

cp "$BOOT_ZIP" "$STAGE/system/media/bootanimation.zip"
cp "$BOOT_ZIP" "$STAGE/system/product/media/bootanimation.zip"

cat > "$STAGE/module.prop" <<PROP
id=$MODULE_ID
name=Cerberus MGM Boot Animation
version=$VERSION
versionCode=$VERSION_CODE
author=Cash + ChatGPT
description=Systemless Cerberus MGM boot animation overlay. Pipeline package; final artwork is user-provided or separately authorized.
PROP

cat > "$STAGE/customize.sh" <<'CUSTOMIZE'
#!/system/bin/sh
ui_print "********************************"
ui_print " Cerberus MGM Boot Animation"
ui_print " Systemless Magisk Module"
ui_print "********************************"
ui_print "Installing bootanimation.zip overlays:"
ui_print " - /system/media/bootanimation.zip"
ui_print " - /system/product/media/bootanimation.zip"
ui_print "No direct system partition writes are performed."
CUSTOMIZE

chmod 0755 "$STAGE/customize.sh"

cat > "$STAGE/META-INF/com/google/android/update-binary" <<'BINARY'
#!/sbin/sh
OUTFD="$2"
ZIPFILE="$3"
ui_print() {
  echo "ui_print $1" > /proc/self/fd/$OUTFD
  echo "ui_print" > /proc/self/fd/$OUTFD
}
ui_print "Install this ZIP with Magisk."
exit 1
BINARY

cat > "$STAGE/META-INF/com/google/android/updater-script" <<'SCRIPT'
#MAGISK
SCRIPT

chmod 0755 "$STAGE/META-INF/com/google/android/update-binary"

rm -f "$OUT_ZIP"
(
  cd "$STAGE"
  zip -r -q "$OUT_ZIP" .
)

echo
echo "Packaged module:"
ls -lh "$OUT_ZIP"
echo
echo "Module contents:"
find "$STAGE" -type f -printf '%P %s bytes\n' | sort

if [ -x "$REPO_DIR/scripts/write_manifest.sh" ]; then
  echo
  echo "Regenerating readme_manifest.md"
  "$REPO_DIR/scripts/write_manifest.sh"
fi

echo
echo "Ready to install manually:"
echo "./scripts/install_module_adb.sh"
