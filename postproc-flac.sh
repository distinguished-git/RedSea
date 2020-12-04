echo "found: $1"
DIRNAME=$( dirname "$1" )

echo "processing album folder: $DIRNAME"
cd "$DIRNAME"


#rm ./valid.log
touch ./valid.log


butler() {
	for flac in *.flac
	do
		
		echo "checking: $flac"
		if grep -Fxq "$flac" ./valid.log
		then 
			echo "already checked"
		else
			if flac --test --warnings-as-errors --silent "$flac" ; 
			then
				echo "$flac" >> ./valid.log
				bpm-tag "$flac"
			else
				rm -f "$flac"
			fi
		fi


		TXTFILE="$(echo "$flac" | sed "s/\.flac/\.txt/")"
		echo "checking for $TEXTFILE"
		if [ -e "$TXTFILE" ]
		then
		    metaflac --import-tags-from "$TXTFILE" "$flac"
		    rm -f $TXTFILE
		fi
	done
}

butler

python3 /tmp/ramdisk/RedSea/redsea.py --preset default --account tv4 --skip "https://tidal.com/browse/album/$(jq '.id' album.json)"

butler

metaflac --add-replay-gain *.flac
