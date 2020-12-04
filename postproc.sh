python3 /tmp/ramdisk/RedSea/redsea.py --preset default --account tv4 --skip --bruteforce "$1"




#delete corrupt flacs
find "/tmp/ramdisk/uploads" -iname "album.json" -exec "/tmp/ramdisk/RedSea/postproc-flac.sh" "{}" \;




exit
DIR="$(pwd)"
screen -dmS dnf sudo dnf install -y jq flac
if ! bpm-tag -h
then
	mkdir /tmp/install-bpm-tools
	cd /tmp/install-bpm-tools
	wget https://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz
	tar -zxvf bpm-tools-0.3.tar.gz
	cd bpm-tools-0.3
	make
	sudo make install
	cd "$DIR"
	rm -rf /tmp/install-bpm-tools
fi

