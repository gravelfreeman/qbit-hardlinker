#!/bin/bash

set -Eeuo pipefail

content_path="${1:?torrent content path is required}"
save_path="${2:?torrent save path is required}"
torrent_category="${3:-}"

source_dir="${QBIT_HARDLINKER_SOURCE_DIR:?QBIT_HARDLINKER_SOURCE_DIR is required}"
destination_dir="${QBIT_HARDLINKER_DEST_DIR:?QBIT_HARDLINKER_DEST_DIR is required}"
mode="${QBIT_HARDLINKER_MODE:-exclude}"
categories="${QBIT_HARDLINKER_CATEGORIES:-}"
log_file="${QBIT_HARDLINKER_LOG_FILE:-/dev/stdout}"

save_path="${save_path%/}"
source_dir="${source_dir%/}"
destination_dir="${destination_dir%/}"

log() {
  printf '[qbit-hardlinker] %s\n' "$1" >> "$log_file"
}

case "$mode" in
  include|exclude) ;;
  *)
    log "[x] Invalid QBIT_HARDLINKER_MODE: $mode"
    exit 1
    ;;
esac

category_matches=false
if [[ -n "$torrent_category" && ",$categories," == *",$torrent_category,"* ]]; then
  category_matches=true
fi

if [[ "$mode:$category_matches" == "include:false" || "$mode:$category_matches" == "exclude:true" ]]; then
  log "[!] Skipped \"${content_path}\": category filtered by $mode mode"
  exit 0
fi

if [[ "$save_path" != "$source_dir" && "$save_path" != "$source_dir/"* ]]; then
  log "[x] Failed to hardlink \"${content_path}\": torrent path is outside source directory"
  exit 1
fi

label="${save_path#"$source_dir"}"
destination_path="${destination_dir}${label}"

if ! mkdir -p "$destination_path"; then
  log "[x] Failed to create destination \"${destination_path}\" for \"${content_path}\""
  exit 1
fi

if cp -Rl "$content_path" "$destination_path"; then
  log "[✔] Successfully hardlinked \"${content_path}\" in \"${destination_path}\""
else
  log "[x] Failed to hardlink \"${content_path}\" in \"${destination_path}\""
  exit 1
fi
