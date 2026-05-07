#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"
start_report "generate-placeholder-frames"

WIDTH="${PLACEHOLDER_WIDTH:-1344}"
HEIGHT="${PLACEHOLDER_HEIGHT:-2992}"
PART0_COUNT="${PART0_FRAMES:-45}"
PART1_COUNT="${PART1_FRAMES:-30}"
PART0_DIR="${PART0_DIR:-$REPO_DIR/bootanimation/part0}"
PART1_DIR="${PART1_DIR:-$REPO_DIR/bootanimation/part1}"
FORCE="${FORCE:-0}"

echo "Generating temporary placeholder frames for packaging tests."
echo "These are NOT final Cerberus artwork."
echo "Resolution: ${WIDTH}x${HEIGHT}"
echo "Part0 frames: $PART0_COUNT"
echo "Part1 frames: $PART1_COUNT"
echo

if ! command -v convert >/dev/null 2>&1; then
  echo "ImageMagick 'convert' is required."
  echo "Install ImageMagick first, or provide real source PNG frames manually."
  exit 1
fi

if [ "$FORCE" != "1" ]; then
  if find "$PART0_DIR" "$PART1_DIR" -maxdepth 1 -type f -name '*.png' | grep -q .; then
    echo "Existing PNG frames detected in part folders."
    echo "Refusing to overwrite without FORCE=1."
    echo "Next step:"
    echo "  FORCE=1 ./scripts/generate_placeholder_frames.sh"
    exit 1
  fi
fi

mkdir -p "$PART0_DIR" "$PART1_DIR"
rm -f "$PART0_DIR"/*.png "$PART1_DIR"/*.png

gen_frame() {
  local out="$1"
  local idx="$2"
  local total="$3"
  local label="$4"
  local pct=$(( idx * 100 / (total > 0 ? total : 1) ))
  convert -size "${WIDTH}x${HEIGHT}" xc:'#0b0b0f' \
    -fill '#1f2a44' -draw "rectangle 0,0 $WIDTH,$((HEIGHT/5))" \
    -fill '#2f3f66' -draw "rectangle 0,$((HEIGHT*4/5)) $WIDTH,$HEIGHT" \
    -fill '#f5f5f5' -gravity center -pointsize 56 \
    -annotate +0-120 "TEMP PLACEHOLDER TEST ART" \
    -pointsize 42 -annotate +0-20 "Cerberus MGM Boot Pipeline" \
    -pointsize 34 -annotate +0+60 "${label} frame ${idx}/${total}" \
    -pointsize 28 -annotate +0+120 "progress ${pct}%" \
    "$out"
}

echo "Writing part0 placeholder frames..."
for i in $(seq 0 $((PART0_COUNT - 1))); do
  printf -v n "%05d" "$i"
  gen_frame "$PART0_DIR/$n.png" "$i" "$PART0_COUNT" "part0 intro"
done

echo "Writing part1 placeholder frames..."
for i in $(seq 0 $((PART1_COUNT - 1))); do
  printf -v n "%05d" "$i"
  gen_frame "$PART1_DIR/$n.png" "$i" "$PART1_COUNT" "part1 loop"
done

echo
echo "Placeholder frames generated."
echo "Next steps:"
echo "  ./scripts/build_bootanimation_zip.sh"
echo "  ./scripts/package_magisk_module.sh"
