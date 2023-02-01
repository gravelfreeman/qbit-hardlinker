# qbit-hardlinker
Bash script to automatically hardlink completed torrents

When a torrent is completed this script will automatically recreate the directory structure¹ and create hardlinks of all the source files to the destination directory of your choice. This is really practical if you want keep seeding on private trackers while being able to post-process your files for your media server without wasting storage space.

¹The script can only re-create 3 levels of directories so be sure to check all your torrents before blindly deleting your files. I wasn't able to increase that limit due to my little knowledge in coding, any help would be greatly appreciated.

## How to use the script

1. Run these commands in a folder qBittorrent have access
```
git clone https://github.com/gravelfreeman/qbit-hardlinker
```
```
chmod +x qbit-hardlinker.sh
```

2. Edit the destination path for your hardlinked files

```
nano qbit-hardlinker.sh
```

3. Modify the destination folder on line 8 and save ``CTRL+X``

> Caution! Destination folder must be on the same dataset and mount path.

4. qBittorent > Tools > Options > Downloads Tab and scroll down to *Run external program* section and check the box *Run external program on torrent finished*

5. Add the script path, ``%N`` and ``%D`` parameters in the text field to match the example below

````
/configs/qbit-hardlinker.sh "%N" "%D"
````


## Optional:

You can also un-comment line 50 to 57 to move single file torrents in a directory with the name of the torrent

````
# Create the subfolder with the torrent name
torrent_folder="$destination/$torrent_name"
if [ ! -d "$torrent_folder" ]; then
   mkdir -p "$torrent_folder"
 fi

 # Create a hardlink to the file in the subfolder
 ln "$download_path/$torrent_name" "$torrent_folder/$torrent_name"
````

## Please read this

I need help to enhance this script. I would like this script to be able to send the hard linked files into a given subfolder based on the tags and/or category of the torrent. And of course I would also like to remove or increase the limit of 3 levels of directories.

## Credits
- MageMinds __ *$GTP Trainer*
- Freeman __ *$Original idea*
- ChatGPT __ *$Programmer*
