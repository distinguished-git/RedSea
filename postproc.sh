while true
do
	find "/tmp/ramdisk/tidal" -cmin +5 -iname "album.json" -exec "/tmp/ramdisk/RedSea/postproc-flac.sh" "{}" \;
	sleep 30
done
