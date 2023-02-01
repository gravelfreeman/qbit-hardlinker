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

# Check if the download is a single file or a folder
if [ -d "$download_path/$torrent_name" ]; then
  # The download is a folder

  # Create the subfolder with the torrent name
  torrent_folder="$destination/$torrent_name"
  if [ ! -d "$torrent_folder" ]; then
    mkdir -p "$torrent_folder"
  fi

  # Recursively copy the folder structure from the download to the destination
  for file in "$download_path/$torrent_name"/*; do
    if [ -d "$file" ]; then
      mkdir "$torrent_folder/$(basename "$file")"
      for subfile in "$file"/*; do
        if [ -d "$subfile" ]; then
          mkdir "$torrent_folder/$(basename "$file")/$(basename "$subfile")"
          for subsubfile in "$subfile"/*; do
            if [ -f "$subsubfile" ]; then
              ln "$subsubfile" "$torrent_folder/$(basename "$file")/$(basename "$subfile")/$(basename "$subsubfile")"
            fi
          done
        elif [ -f "$subfile" ]; then
          ln "$subfile" "$torrent_folder/$(basename "$file")/$(basename "$subfile")"
        fi
      done
    elif [ -f "$file" ]; then
      ln "$file" "$torrent_folder/$(basename "$file")"
    fi
  done
else
  # The download is a single file

#  # Create the subfolder with the torrent name
#  torrent_folder="$destination/$torrent_name"
#  if [ ! -d "$torrent_folder" ]; then
#    mkdir -p "$torrent_folder"
#  fi

#  # Create a hardlink to the file in the subfolder
#  ln "$download_path/$torrent_name" "$torrent_folder/$torrent_name"

  # Create a hardlink to the file in the destination folder
  ln "$download_path/$torrent_name" "$destination/$torrent_name"
fi

echo "qbit-hardlinker task successfull"