#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"
start_report "build-bootanimation-zip"

WIDTH="${BOOT_WIDTH:-1344}"
HEIGHT="${BOOT_HEIGHT:-2992}"
FPS="${BOOT_FPS:-30}"
PART0_MODE="${PART0_MODE:-p}"
PART0_COUNT="${PART0_COUNT:-1}"
PART0_PAUSE="${PART0_PAUSE:-0}"
PART1_MODE="${PART1_MODE:-c}"
PART1_COUNT="${PART1_COUNT:-0}"
PART1_PAUSE="${PART1_PAUSE:-0}"
OUT_ZIP="${OUT_ZIP:-$REPO_DIR/bootanimation/bootanimation.zip}"
DESC_FILE="$REPO_DIR/bootanimation/desc.txt"
PART0="$REPO_DIR/bootanimation/part0"
PART1="$REPO_DIR/bootanimation/part1"

echo "Building Android bootanimation.zip"
echo "Repo: $REPO_DIR"
echo "Resolution: ${WIDTH}x${HEIGHT}"
echo "FPS: $FPS"
echo "Output: $OUT_ZIP"
echo

mkdir -p "$PART0" "$PART1" "$(dirname "$OUT_ZIP")"

validate_part() {
  local part_dir="$1"
  local part_name="$2"
  local count=0

  echo "Validating $part_name frames in $part_dir"
  while IFS= read -r frame; do
    count=$((count + 1))
    local base
    base="$(basename "$frame")"
    if [[ ! "$base" =~ ^[0-9]+\.png$ ]]; then
      echo "Invalid frame name: $part_name/$base"
      echo "Use sequential numeric PNG names such as 00000.png, 00001.png, 00002.png."
      return 1
    fi
  done < <(find "$part_dir" -maxdepth 1 -type f -name "*.png" | sort)

  if [ "$count" -eq 0 ]; then
    echo "No PNG frames found in $part_name."
    echo "Drop source PNG frames into bootanimation/$part_name/ before building."
    return 1
  fi

  echo "$part_name: $count PNG frame(s)"
}

validate_part "$PART0" "part0"
validate_part "$PART1" "part1"

cat > "$DESC_FILE" <<DESC
$WIDTH $HEIGHT $FPS
$PART0_MODE $PART0_COUNT $PART0_PAUSE part0
$PART1_MODE $PART1_COUNT $PART1_PAUSE part1
DESC

echo
echo "Generated desc.txt:"
cat "$DESC_FILE"

rm -f "$OUT_ZIP"
(
  cd "$REPO_DIR/bootanimation"
  echo
  echo "Creating ZIP with storage mode (-0), preferred for Android boot animations."
  zip -0 -q -r "$OUT_ZIP" desc.txt part0 part1
)

echo
ls -lh "$OUT_ZIP"

if [ -x "$REPO_DIR/scripts/write_manifest.sh" ]; then
  echo
  echo "Regenerating readme_manifest.md"
  "$REPO_DIR/scripts/write_manifest.sh"
fi

echo
echo "Bootanimation ZIP built successfully."
