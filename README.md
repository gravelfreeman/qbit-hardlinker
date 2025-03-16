# qbit-hardlinker
### Bash Script to Automatically Hardlink Completed Torrents

This script automatically recreates the directory structure and creates hardlinks for all source files to a destination directory of your choice when a torrent is completed. It’s particularly useful for keeping seeding on private trackers while post-processing files for your media server without wasting storage space.

The script works independently from the Arrs hardlink functionality, so you can keep the hardlink option enabled in Arrs. Your apps will continue managing the hardlinks in your media library without any conflicts.

> **Note :**
> 
> This script will **also** hardlink downloads from the Arrs into your path/to/destination folder, which means you'll have to delete those files manually or automate the deletion. We're looking for a PR to add functionality that prevents the script from executing if the category folder matches a value from a comma-separated list of excluded categories, which will be added to the script.

## How to use the script

1. Run these commands in a folder qBittorrent have access

```
git clone https://github.com/gravelfreeman/qbit-hardlinker
```
```
chmod +x qbit-hardlinker.sh
```

2. Edit the destination path, and base_path for your hardlinked files, base path is likely the same as your "default save path"

```
nano qbit-hardlinker.sh
```

3. Modify the variables on line 9 & 10.

> **Note :**
>
> Destination folder must be on the same dataset and mount path.

4. qBittorent > Tools > Options > Downloads Tab and scroll down to *Run external program* section and check the box *Run external program on torrent finished*

5. Add the script path in the text field to match the example below

````
/config/qBittorrent/qbit-hardlinker.sh "%K" "%N" "%D"
````

## Credits
- Paul Chambers - [Original Code](https://gist.github.com/paul-chambers/71ef48e40449ec73eef95430b9e4e6c7)
