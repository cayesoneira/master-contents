#! bin/bash
# Program to change names of files

for d in */
do 

cd ${d}

dirname=`pwd`
shopt -s extglob           # enable +(...) glob syntax
result=${dirname%%+(/)}    # trim however many trailing slashes exist
result=${result##*/}       # remove everything before the last / that still remains
result=${result:-/}        # correct for dirname=/ case

echo ${result}

for file in *
do
  mv $file ${result}_$file
done

cd ../
done
