#!/bin/bash

set -x

torrentName=$1
torrentPath=$2
torrentCategory=$3

srcDir="/path/to/source"
destDir="/path/to/destination"

excludedCategories="radarr,sonarr,lidarr,readarr"

logDir="$(dirname "$0")"

if [[ ",$excludedCategories," == *",$torrentCategory,"* ]]; then
  echo "[!] Skipped \"${torrentName}\" has excluded \"${torrentCategory}\" category set" >> "$logDir/qbit-hardlinker.log"
  exit 0
fi

label="${torrentPath#$srcDir}"

srcPath="${torrentPath}/${torrentName}"
destPath="${destDir}${label}"

mkdir -p -- "$destPath" || exit 1

if cp -vrl -t "$destPath" -- "$srcPath"; then
  echo "[✔] Successfully hardlinked \"${torrentName}\" in \"${destPath}\"" >> "$logDir/qbit-hardlinker.log"
else
  echo "[x] Failed to hardlink \"${torrentName}\" in \"${destPath}\"" >> "$logDir/qbit-hardlinker.log"
  exit 1
fi