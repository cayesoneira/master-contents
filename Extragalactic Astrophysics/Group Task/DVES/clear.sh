#! bin/bash
# Program to extract the chi's from all the files

touch chis.dat
rm chis.dat
touch chis.dat

for file in *DVES.chi
do

cat $file | grep -v '#' | awk '{print $1,$2}' >> chis.dat

done
