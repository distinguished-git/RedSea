cat albums.txt | while read line 
do
   ./postproc.sh "$line"
done
