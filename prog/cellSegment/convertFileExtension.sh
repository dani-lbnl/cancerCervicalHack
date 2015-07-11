#!/bin/sh

path=" /Users/ushizima/Dropbox/aqui/others/Cervix/git/CRIC/hackathon/images/exampleSubset/seg/"
files=$path*tif

#Convert files keeping old ones!
for i in $files #you don't need both sides!
do
	#newname=`echo $i | sed 's/.tif/s.jpg/g'`
	newname=`echo $i | sed 's/.tif/.png/g'`
	#echo $newname
	convert $i $newname
	#convert -resize 20% $i $newname
	#convert -size 1920x1080 xc:black $newname
	#composite -geometry 1280x720+320+180 $i $newname $newname
done


 

