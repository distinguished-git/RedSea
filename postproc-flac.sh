DIRNAME="$1"

echo "processing album folder: $DIRNAME"
cd "$DIRNAME"


touch ./valid.log


butler() {
	for flac in *.flac
	do
		
		echo "checking: $flac"
		if grep -Fxq "$flac" ./valid.log
		then 
			echo "already checked"
			exit 0
		fi

		# if there's a problem with the flac file
		if flac --test --warnings-as-errors --silent "$flac" ; 
		then
			echo "$flac" >> ./valid.log

			TXTFILE="$(echo "$flac" | sed "s/\.flac/\.txt/")"
			if [ -e $TXTFILE ]
			then
			    metaflac --import-tags-from "$TXTFILE" "$flac"
			    rm -f $TXTFILE
			fi
		else
			rm -f "$flac"
		fi
	done
}

butler

python3 /tmp/ramdisk/RedSea/redsea.py --preset default --account tv4 --skip "https://tidal.com/browse/album/$(jq '.id' album.json)"

butler

flac --replay-gain --keep-foreign-metadata *.flac
