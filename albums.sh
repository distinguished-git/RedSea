cat albums.txt | while read line 
do
	echo "https://tidal.com/browse/album/$line"
   ./postproc.sh "https://listen.tidal.com/album/$line"
done
