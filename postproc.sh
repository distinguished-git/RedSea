sudo dnf install -y jq flac

touch valid.log


#delete corrupt flacs
find "/tmp/ramdisk/tidal" -iname "album.json" -exec "/tmp/ramdisk/RedSea/postproc-flac.sh" "$( dirname "{}" )" \;


