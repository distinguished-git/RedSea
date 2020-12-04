cat albums.txt | while read line 
do
	echo "https://listen.tidal.com/album/$line"
   ./postproc.sh "https://listen.tidal.com/album/$line"
done
