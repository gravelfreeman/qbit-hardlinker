#!/usr/bin/env bash

set -Eeuo pipefail

repository_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="$repository_dir/qbit-hardlinker.sh"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

# Build a small fixture used to exercise the environment variable combinations.
source_dir="$test_root/source"
source_file="$source_dir/torrents/library/file.txt"
mkdir -p "$(dirname "$source_file")"
printf 'test file\n' > "$source_file"

# Clear every QBIT variable before applying a test scenario.
unset_qbit_environment=(
  -u QBIT_HARDLINKER_SOURCE_DIR
  -u QBIT_HARDLINKER_DEST_DIR
  -u QBIT_HARDLINKER_MODE
  -u QBIT_HARDLINKER_CATEGORIES
  -u QBIT_HARDLINKER_LOG_FILE
)

# The unset marker omits a variable; empty keeps it defined with no value.
run_script() {
  local mode="$1"
  local categories="$2"
  local category="$3"
  local destination_dir="$4"
  local expected_status="$5"
  local log_mode="${6:-set}"
  local actual_status
  local environment=(
    "QBIT_HARDLINKER_SOURCE_DIR=$source_dir"
    "QBIT_HARDLINKER_DEST_DIR=$destination_dir"
  )

  if [[ "$mode" != unset ]]; then
    environment+=("QBIT_HARDLINKER_MODE=$mode")
  fi
  if [[ "$categories" != unset ]]; then
    environment+=("QBIT_HARDLINKER_CATEGORIES=$categories")
  fi
  if [[ "$log_mode" == empty ]]; then
    environment+=("QBIT_HARDLINKER_LOG_FILE=")
  elif [[ "$log_mode" != unset ]]; then
    environment+=("QBIT_HARDLINKER_LOG_FILE=$test_root/test.log")
  fi

  if env "${unset_qbit_environment[@]}" "${environment[@]}" bash "$script_path" library "$source_dir/torrents" "$category" >/dev/null; then
    actual_status=0
  else
    actual_status=$?
  fi

  [[ "$actual_status" -eq "$expected_status" ]]
}

# Confirm that a matching category copies the fixture.
assert_copy() {
  local destination_dir="$1"
  local destination_file="$destination_dir/torrents/library/file.txt"

  [[ -f "$destination_file" ]]
  cmp -s "$source_file" "$destination_file"
}

# Include mode copies a matching category and skips non-matching or empty categories.
include_destination="$test_root/include"
run_script include library library "$include_destination" 0
assert_copy "$include_destination"

include_nonmatching_destination="$test_root/include-nonmatching"
run_script include movies library "$include_nonmatching_destination" 0
[[ ! -e "$include_nonmatching_destination" ]]

include_empty_category_destination="$test_root/include-empty-category"
run_script include library '' "$include_empty_category_destination" 0
[[ ! -e "$include_empty_category_destination" ]]

include_empty_destination="$test_root/include-empty"
run_script include '' library "$include_empty_destination" 0
[[ ! -e "$include_empty_destination" ]]

include_unset_destination="$test_root/include-unset"
run_script include unset library "$include_unset_destination" 0
[[ ! -e "$include_unset_destination" ]]

# Exclude mode skips a matching category and copies non-matching or empty categories.
exclude_destination="$test_root/exclude"
run_script exclude library library "$exclude_destination" 0
[[ ! -e "$exclude_destination" ]]

exclude_nonmatching_destination="$test_root/exclude-nonmatching"
run_script exclude radarr library "$exclude_nonmatching_destination" 0
assert_copy "$exclude_nonmatching_destination"

exclude_empty_category_destination="$test_root/exclude-empty-category"
run_script exclude library '' "$exclude_empty_category_destination" 0
assert_copy "$exclude_empty_category_destination"

exclude_empty_destination="$test_root/exclude-empty"
run_script exclude '' library "$exclude_empty_destination" 0
assert_copy "$exclude_empty_destination"

exclude_unset_destination="$test_root/exclude-unset"
run_script exclude unset library "$exclude_unset_destination" 0
assert_copy "$exclude_unset_destination"

# Empty or unset mode defaults to exclude, with either an empty or populated list.
default_destination="$test_root/default"
run_script '' '' library "$default_destination" 0
assert_copy "$default_destination"

empty_mode_destination="$test_root/empty-mode"
run_script '' library library "$empty_mode_destination" 0
[[ ! -e "$empty_mode_destination" ]]

unset_destination="$test_root/unset"
run_script unset unset library "$unset_destination" 0 unset
assert_copy "$unset_destination"

unset_mode_destination="$test_root/unset-mode"
run_script unset library library "$unset_mode_destination" 0
[[ ! -e "$unset_mode_destination" ]]

# An empty log path uses the stdout default.
empty_log_destination="$test_root/empty-log"
run_script exclude '' library "$empty_log_destination" 0 empty
assert_copy "$empty_log_destination"

# Invalid modes fail before any files are copied.
invalid_destination="$test_root/invalid"
run_script invalid library library "$invalid_destination" 1

# Required source and destination variables fail when missing or empty.
if env "${unset_qbit_environment[@]}" \
  QBIT_HARDLINKER_DEST_DIR="$test_root/missing-source" \
  bash "$script_path" library "$source_dir/torrents" library >/dev/null 2>&1; then
  exit 1
fi

if env "${unset_qbit_environment[@]}" \
  QBIT_HARDLINKER_SOURCE_DIR="$source_dir" \
  bash "$script_path" library "$source_dir/torrents" library >/dev/null 2>&1; then
  exit 1
fi

if env "${unset_qbit_environment[@]}" \
  QBIT_HARDLINKER_SOURCE_DIR= \
  QBIT_HARDLINKER_DEST_DIR="$test_root/empty-source" \
  bash "$script_path" library "$source_dir/torrents" library >/dev/null 2>&1; then
  exit 1
fi

if env "${unset_qbit_environment[@]}" \
  QBIT_HARDLINKER_SOURCE_DIR="$source_dir" \
  QBIT_HARDLINKER_DEST_DIR= \
  bash "$script_path" library "$source_dir/torrents" library >/dev/null 2>&1; then
  exit 1
fi

printf 'environment tests passed\n'
