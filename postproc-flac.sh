echo "found: $1"
DIRNAME=$( dirname "$1" )

echo "processing album folder: $DIRNAME"
cd "$DIRNAME"


rm ./valid.log
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
			else
				rm -f "$flac"
			fi
		fi
	done
}

butler

python3 /tmp/ramdisk/RedSea/redsea.py --preset default --account tv4 --skip --bruteforce "https://tidal.com/browse/album/$(jq '.id' album.json)"

butler

for flac in *.flac
do
	bpm-tag "$flac"
	TXTFILE="$(echo "$flac" | sed "s/\.flac/\.txt/")"
	echo "checking for $TXTFILE"
	if [ -e "$TXTFILE" ]
	then
	    metaflac --import-tags-from "$TXTFILE" "$flac"
	    rm -f $TXTFILE
	fi
done

metaflac --add-replay-gain *.flac


find "$(pwd)" -iname "*.flac" -o -iname "*.lrc" | sed -e "s/\/tmp\/ramdisk\/tidal\//\//" > include.txt
gclone move --size-only /tmp/ramdisk/tidal --include-from "include.txt" union:/Music --progress --transfers 20
cd /tmp/ramdisk/RedSea
rm -rf "$DIRNAME"
