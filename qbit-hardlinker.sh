#!/bin/bash

set -x

torrentID=$1
torrentName=$2
torrentPath=$3

srcDir="path/to/source"
destDir="path/to/destination"

label="${torrentPath#$srcDir}"

srcPath="${torrentPath}/${torrentName}"
destPath="${destDir}${label}/${torrentName}"

mkdir -p "~/logs/"
echo "${torrentID} \"${torrentName}\" \"${torrentPath}\" ${label}" >> ~/logs/qbit-hardlinker.log

mkdir -p "${destPath}${label}"
cp -vrl -t "${destDir}${label}" "${srcPath}"
