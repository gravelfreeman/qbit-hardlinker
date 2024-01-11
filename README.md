# qbit-hardlinker
Bash script to automatically hardlink completed torrents

When a torrent is completed this script will automatically recreate the directory structure and create hardlinks of all the source files to the destination directory of your choice. This is really practical if you want keep seeding on private trackers while being able to post-process your files for your media server without wasting storage space.

This should support using categories with *arr apps to isolate downloads as long as they're subpaths of your base path. 


## How to use the script

1. Run these commands in a folder qBittorrent have access
```shell
git clone https://github.com/gravelfreeman/qbit-hardlinker
```

```shell
chmod +x qbit-hardlinker.sh
```

2. Edit the destination path, and base_path for your hardlinked files, base path is likely the same as your "default save path"

```shell
nano qbit-hardlinker.sh
```

3. Modify the variables on line 7 & 12  and save `CTRL+X`

> Caution! Destination folder must be on the same dataset and mount path.

4. qBittorent > Tools > Options > Downloads Tab and scroll down to *Run external program* section and check the box *Run external program on torrent finished*

5. Add the script path, `%F` in the text field to match the example below

```
/configs/qbit-hardlinker.sh "%F"
```

If all your torrents always have folders you may use `%R` instead of `%F`.

From the settings page:

> %F: Content path (same as root path for multi-file torrent)
>
> %R: Root path (first torrent subdirectory path)


## Optional:

You can also update line 19 to `true` in order to clean up empty folders from previously snatched torrents. This should only delete empty folder paths so should be rather risk free.


## Credits
- Dgibbons __ Code fixes to remove limit
- MageMinds __ *$GTP Trainer*
- Freeman __ *$Original idea*
- ChatGPT __ *$Programmer*
