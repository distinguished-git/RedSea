sudo dnf install -y jq flac

touch valid.log


#delete corrupt flacs
find "/tmp/ramdisk/tidal" -iname "album.json" -exec "/tmp/ramdisk/RedSea/postproc-flac.sh" "$( dirname "{}" )" \;

#download new/missing ones
python3 /tmp/ramdisk/RedSea/redsea.py --preset default --account tv4 --skip "https://tidal.com/browse/album/$(jq '.id' album.json)"

#delete any corrupt ones
find "/tmp/ramdisk/tidal" -iname "*.flac" -exec "/tmp/ramdisk/RedSea/postproc-flac.sh" "{}" \;

metaflac --add-replay-gain *.flac

