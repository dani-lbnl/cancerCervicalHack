#!/bin/sh

#setting parameters
prefix="isbi_train45_im"
extension="png"
path=" /Users/ushizima/Dropbox/aqui/others/Cervix/git/CRIC/hackathon/images/exampleSubset/seg/"

#Before running, test by commenting the mv command
echo "..........Renaming files............"
filename=$path$prefix
echo "Changing names for files at $filename"

#Assuming you have only thousands of images and they are all png
f1=$(ls -la -C1 $filename?.$extension)
f2=$(ls -la -C1 $filename??.$extension)
f3=$(ls -la -C1 $filename???.$extension)

k=0
for i in $f1
do
	newname=$filename"000$k."$extension
	mv $i $newname
	echo "Changed $i to $newname"
	k=$((k+1)) #or let i+=1
done

k=10 #must be 10 - attribution just in case there's some missing file
for i in $f2
do
	newname=$filename"00$k."$extension
	mv $i $newname
	#echo "Changed $i for $newname"
	k=$((k+1)) #or let i+=1
done

k=100
for i in $f3
do
    newname=$filename"0$k."$extension
	mv $i $newname
	#echo "Changed $i for $newname"
	k=$((k+1)) #or let i+=1
done

echo "--------DONE----------"

 

