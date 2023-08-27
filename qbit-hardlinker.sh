#!/bin/bash

# Get the path to the download and the name of the torrent
download_path="$2"
torrent_name="$1"

# The destination folder
destination="/media/ready"

# Validate that the required parameters have been passed
if [ -z "$download_path" ] || [ -z "$torrent_name" ] || [ -z "$destination" ]; then
  echo "Error: missing required parameters."
  echo "Usage: $0 <torrent name> <download path>"
  exit 1
fi

cp -lR "$download_path/$torrent_name" "$destination/"

echo "qbit-hardlinker task successfull"