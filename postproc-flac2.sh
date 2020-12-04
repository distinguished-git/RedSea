echo "found: $1"
DIRNAME=$( dirname "$1" )

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

for flac in *.flac
do
	nice bpm-tag "$flac"
	TXTFILE="$(echo "$flac" | sed "s/\.flac/\.txt/")"
	echo "checking for $TXTFILE"
	if [ -e "$TXTFILE" ]
	then
	    nice metaflac --import-tags-from "$TXTFILE" "$flac"
	    rm -f $TXTFILE
	fi
done

nice metaflac --add-replay-gain *.flac


find "$(pwd)" -iname "*.flac" -o -iname "*.lrc" -o -iname "*.log" | sed -e "s/\/tmp\/ramdisk\/tidal\//\//" > include.txt
gclone move --size-only /tmp/ramdisk/tidal --include-from "include.txt" union:/Music --progress --transfers 10 --fast-list --tpslimit 8
cd /tmp/ramdisk/RedSea
rm -rf "$DIRNAME"

