<h3 align="center">
	<img src="https://github.com/user-attachments/assets/fbe1e764-bb1c-42cf-b22d-ddce7ed4830d" width="100" alt="Logo"/><br/>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
	qbit-hardlinker
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
</h3>

<p align="center">
	<a href="https://github.com/gravelfreeman/qbit-hardlinker/stargazers"><img src="https://img.shields.io/github/stars/gravelfreeman/qbit-hardlinker?colorA=363a4f&colorB=b7bdf8&style=for-the-badge"></a>
	<a href="https://github.com/gravelfreeman/qbit-hardlinker/issues"><img src="https://img.shields.io/github/issues/gravelfreeman/qbit-hardlinker?colorA=363a4f&colorB=f5a97f&style=for-the-badge"></a>
	<a href="https://github.com/gravelfreeman/qbit-hardlinker/contributors"><img src="https://img.shields.io/github/contributors/gravelfreeman/qbit-hardlinker?colorA=363a4f&colorB=a6da95&style=for-the-badge"></a>
</p>

This script automatically recreates the directory structure and creates hardlinks for all source files to a destination directory of your choice when a torrent is completed.

It’s particularly useful for keeping seeding on private trackers while post-processing files for your media server without wasting storage space.

The script works independently from the Arrs hardlink functionality, so you can keep the hardlink option enabled in Arrs.

## Usage

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

3. Modify the variable on line 9 to set your qBittorrent download directory.
4. Modify the variable on line 10 to set your hardlink destination directory.

> **Note :**
>
> Source and destination folders must be on the same dataset and mount path.

5. Modify the variables on line 12 to set excluded qBittorrent categories.

> **Note :**
> 
> It's recommended to exclude the Arrs categories since those apps are already managing your media and their hardlinks.

4. qBittorent > Tools > Options > Downloads Tab and scroll down to *Run external program* section and check the box *Run external program on torrent finished*

5. Add the script path in the text field followed by `"%N" "%D" "%L"` variables.

Example :
```
/config/qbit-hardlinker/qbit-hardlinker.sh "%N" "%D" "%L"
```

## Credits
- Paul Chambers - [Original Code](https://gist.github.com/paul-chambers/71ef48e40449ec73eef95430b9e4e6c7)
