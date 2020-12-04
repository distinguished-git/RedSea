echo "found: $1"
DIRNAME=$( dirname "$1" )

echo "processing album folder: $DIRNAME"
cd "$DIRNAME"

mv -f album.json album.log || exit

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
			else
				rm -f "$flac"
			fi
		fi
	done
}

butler

python3 /tmp/ramdisk/RedSea/redsea.py --preset default --account tv4 --skip --bruteforce "https://tidal.com/browse/album/$(jq '.id' album.log)"


screen -dmS flac2 /tmp/ramdisk/RedSea/postproc-flac2.sh
