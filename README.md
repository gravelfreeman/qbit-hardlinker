<h3 align="center">
	<img src="assets/qbit-hardlinker.svg" width="100" alt="qbit-hardlinker logo"/><br/>
</h3>

<p align="center">
	<a href="https://github.com/gravelfreeman/qbit-hardlinker/stargazers"><img src="https://img.shields.io/github/stars/gravelfreeman/qbit-hardlinker?colorA=363a4f&colorB=b7bdf8&style=for-the-badge"></a>
	<a href="https://github.com/gravelfreeman/qbit-hardlinker/issues"><img src="https://img.shields.io/github/issues/gravelfreeman/qbit-hardlinker?colorA=363a4f&colorB=f5a97f&style=for-the-badge"></a>
	<a href="https://github.com/gravelfreeman/qbit-hardlinker/contributors"><img src="https://img.shields.io/github/contributors/gravelfreeman/qbit-hardlinker?colorA=363a4f&colorB=a6da95&style=for-the-badge"></a>
</p>

This script automatically recreates the directory structure and creates hardlinks for all source files to a destination directory when a torrent is completed.

It’s particularly useful for keeping seeding on private trackers while post-processing files for your media server without wasting storage space.

The script works independently from the Arrs hardlink functionality, so you can keep the hardlink option enabled in Arrs.

## qBittorrent Settings

1. **qBittorrent** > **Tools** > **Options** > **Downloads** Tab and scroll down to **Run external program** section
2. Check the box **Run external program on torrent finished**
3. Add the script path in the text field followed by `"%N" "%D" "%L"` variables.

```
/config/qbit-hardlinker/qbit-hardlinker.sh "%N" "%D" "%L"
```

## Variables

For Docker and Kubernetes, set these environment variables in the qBittorrent
container:

| Variable | | Default | Description |
| --------------------------- | :-: | :-------: | -------------------------------- |
| `QBIT_HARDLINKER_SOURCE_DIR` | Required | — | Root directory containing the torrents. |
| `QBIT_HARDLINKER_DEST_DIR` | Required | — | Root directory where hardlinks are created. |
| `QBIT_HARDLINKER_EXCLUDED_CATEGORIES` | Optional | Empty | Comma-separated list of categories to skip. |
| `QBIT_HARDLINKER_LOG_FILE` | Optional | `/dev/stdout` | Log file location. |

## Arrs Exclusion

It's recommended to exclude the Arrs categories since those apps are already managing your media and their hardlinks:

```
QBIT_HARDLINKER_EXCLUDED_CATEGORIES=radarr,sonarr,lidarr,readarr
```

## Examples

### Docker Example

Mount the script and the shared media directory into the qBittorrent container:

```yaml
services:
  qbittorrent:
    environment:
      QBIT_HARDLINKER_SOURCE_DIR: /media/torrents
      QBIT_HARDLINKER_DEST_DIR: /media/hardlinks
      QBIT_HARDLINKER_EXCLUDED_CATEGORIES: radarr,sonarr,lidarr,readarr
    volumes:
      - ./qbit-hardlinker.sh:/config/qbit-hardlinker/qbit-hardlinker.sh:ro
      - /path/to/media:/media
```

### Kubernetes Example

> [!NOTE]
> For a live example from my cluster, see [k8s-gitops](https://github.com/gravelfreeman/k8s-gitops/tree/main/kubernetes/apps/media/torrent/scripts). It demonstrates a clean, multi-instance qBittorrent setup managed with Flux and Kustomize.

Create a ConfigMap from the script:

```bash
kubectl create configmap qbit-hardlinker \
  --from-file=qbit-hardlinker.sh=./qbit-hardlinker.sh \
  --dry-run=client -o yaml | kubectl apply -f -
```

Add the following parts to the existing qBittorrent Deployment:

```yaml
env:
  - name: QBIT_HARDLINKER_SOURCE_DIR
    value: /media/torrents
  - name: QBIT_HARDLINKER_DEST_DIR
    value: /media/hardlinks
  - name: QBIT_HARDLINKER_EXCLUDED_CATEGORIES
    value: radarr,sonarr,lidarr,readarr
  - name: QBIT_HARDLINKER_LOG_FILE
    value: /dev/stdout

volumeMounts:
  - name: qbit-hardlinker
    mountPath: /config/qbit-hardlinker
  - name: media
    mountPath: /media

volumes:
  - name: qbit-hardlinker
    configMap:
      name: qbit-hardlinker
      defaultMode: 0555
  - name: media
    persistentVolumeClaim:
      claimName: media
```

### Linux / macOS Example

> [!IMPORTANT]
> For a native installation, it is recommended to edit the script directly
instead of relying on `export`.

Edit these lines in `qbit-hardlinker.sh`:

```bash
source_dir="/path/to/torrents"                            # line 9
destination_dir="/path/to/hardlinks"                      # line 10
excluded_categories="radarr,sonarr,lidarr,readarr"        # line 11
log_file="/logs/qbit-hardlinker.log"                      # line 12
```

Then make the script executable:

```bash
chmod +x qbit-hardlinker.sh
```
