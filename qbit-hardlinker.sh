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
destPath="${destDir}${label}/${torrentName}"

echo "[✔] Successfully hardlinked \"${torrentName}\" in \"${destDir}${label}\"" >> "$logDir/qbit-hardlinker.log"

cp -vrl -t "${destDir}${label}" "${srcPath}"
