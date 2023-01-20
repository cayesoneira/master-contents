#!/bin/bash
#
# Assignment for the course Programming in Scientific environment M1992.
#
# Author: Cayetano Soneira
# Created: 2022-10-17

function get_number(){
  grep number $1 | cut -d '>' -f 2 | cut -d '<' -f 1
}

function get_name(){
  grep name $1 | cut -d '"' -f 2
}

rm -r shell-lesson-data
rm shell-lesson-data.zip

# 1. Download the file https://raw.githubusercontent.com/swcarpentry/shell-novice/f32646f/data/shell-lesson-data.zip
wget https://raw.githubusercontent.com/swcarpentry/shell-novice/f32646f/data/shell-lesson-data.zip

# 2. Unzip it
unzip shell-lesson-data.zip

# 3. Read the .xml files in folder data/elements and copy them in another (new) folder named elements_by_atomic_number & 4. The file names in this folder should follow the pattern e.g. 008_Oxigen.xml.

mkdir -p shell-lesson-data/data/elements_by_atomic_number

cp -R shell-lesson-data/data/elements shell-lesson-data/data/elements_by_atomic_number

cd shell-lesson-data/data/elements_by_atomic_number

for file in elements/*.xml
do
  number=$(get_number ${file})
  name=$(get_name ${file})
  ticket=$((number))
  if [ $((number)) -lt 10 ]
  then
  	mv ${file} elements/00${number}_${name}.xml
  elif [ $((number)) -lt 100 ] && [ $((number)) -gt 10 ] || [ $((number)) -eq 10 ] 
  then
  	mv ${file} elements/0${number}_${name}.xml
  else
  	mv ${file} elements/${number}_${name}.xml
  fi
done

# 5. Change file permissions to be writable by the group and have no read/write permissions for other users.
sudo chmod -R 751 elements

# 6. Create a tar.gz file with these new files, removing all intermediate files and folders created.
tar -czvf elements.tar.gz elements
cp elements.tar.gz /home/cayesoneira/Notebooks/shell

cd /home/cayesoneira/Notebooks/shell
rm -r shell-lesson-data
rm shell-lesson-data.zip

# To extract files: tar -x -f elements.tar.gz
