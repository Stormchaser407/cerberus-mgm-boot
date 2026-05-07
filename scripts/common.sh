#!/usr/bin/env bash

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || pwd
}

timestamp() {
  date +"%Y%m%d-%H%M%S"
}

start_report() {
  local name="$1"
  local root
  root="$(repo_root)"
  mkdir -p "$root/reports"
  REPORT="$root/reports/${name}-$(timestamp).txt"
  export REPORT
  exec > >(tee "$REPORT") 2>&1
  trap finish_report EXIT
}

finish_report() {
  local status=$?
  if [ -n "${REPORT:-}" ] && [ -f "$REPORT" ]; then
    echo
    echo "Report: $REPORT"
    if command -v xclip >/dev/null 2>&1; then
      xclip -selection clipboard < "$REPORT"
      echo "Copied report to clipboard with xclip."
    else
      echo "xclip not found; report was not copied to clipboard."
    fi
  fi
  exit "$status"
}

adb_run() {
  if [ -n "${ADB:-}" ] && command -v "$ADB" >/dev/null 2>&1; then
    "$ADB" "$@"
  elif command -v adb >/dev/null 2>&1; then
    adb "$@"
  elif command -v nix-shell >/dev/null 2>&1; then
    local quoted=""
    local arg
    for arg in "$@"; do
      quoted+=" $(printf "%q" "$arg")"
    done
    nix-shell -p android-tools --run "adb$quoted"
  else
    echo "adb not found. Install android-tools or run with ADB=/path/to/adb."
    return 127
  fi
}

su_run() {
  local cmd="$1"
  local escaped
  escaped="${cmd//\'/\'\\\'\'}"
  adb_run shell "su -c '$escaped'"
}

latest_file() {
  local pattern="$1"
  ls -t $pattern 2>/dev/null | head -n 1
}
