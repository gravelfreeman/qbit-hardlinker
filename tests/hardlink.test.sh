#!/usr/bin/env bash

set -Eeuo pipefail

repository_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="$repository_dir/qbit-hardlinker.sh"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

# Build 100 nested directories with 100 files at every level.
source_dir="$test_root/source"
source_tree="$source_dir/torrents/library"
mkdir -p "$source_tree"

current_directory="$source_tree"
for directory_index in $(seq 1 100); do
  current_directory="$current_directory/level-$directory_index"
  mkdir -p "$current_directory"
  for file_index in $(seq 1 100); do
    printf 'level %s file %s\n' "$directory_index" "$file_index" > "$current_directory/file-$file_index.txt"
  done
done

# Return a file inode on both GNU and BSD stat implementations.
file_inode() {
  if stat -c '%i' "$1" 2>/dev/null; then
    return
  fi
  stat -f '%i' "$1"
}

# Return the representative file at a given nesting level.
sample_file() {
  local level="$1"
  local sample_directory="$source_tree"
  local current_level

  for current_level in $(seq 1 "$level"); do
    sample_directory="$sample_directory/level-$current_level"
  done

  printf '%s/file-%s.txt\n' "$sample_directory" "$level"
}

# Verify the complete tree, file contents, and representative hardlinks.
assert_tree() {
  local destination_tree="$1/torrents/library"
  local level
  local source_entry
  local destination_entry
  local relative_entry

  diff -rq "$source_tree" "$destination_tree"

  for level in 1 50 100; do
    source_entry="$(sample_file "$level")"
    relative_entry="${source_entry#"$source_tree"}"
    destination_entry="$destination_tree$relative_entry"
    [[ "$(file_inode "$source_entry")" == "$(file_inode "$destination_entry")" ]]
  done
}

# Copy the complete nested tree as hardlinks.
destination_dir="$test_root/destination"
QBIT_HARDLINKER_SOURCE_DIR="$source_dir/" \
QBIT_HARDLINKER_DEST_DIR="$destination_dir/" \
QBIT_HARDLINKER_MODE=include \
QBIT_HARDLINKER_CATEGORIES=library \
QBIT_HARDLINKER_LOG_FILE="$test_root/test.log" \
bash "$script_path" library "$source_dir/torrents" library >/dev/null

assert_tree "$destination_dir"
printf 'hardlink tests passed\n'
