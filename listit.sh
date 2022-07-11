#!/bin/bash
# Author: Ryan Pillay (ryanpillayza@protonmail.com)
# for use in bash/shell environments only
# Make sure this script is executable (sudo chmod +x listit.sh)
# Accepts and uses 1 input parameter (type integer) via $1 ARG. This is used to print X amount of lines in the file directories.list

#create dir
touch directories.list
#lists all directories in current directory in line format, outputs stdout to directories.list file
ls -dl */ > directories.list
#inserts string into first line of directories.list
sed -i "line one's line" directories.list
#prints first $1 amount of lines in directories.list. $1 is the stdin first input parameter when executing the script 
head -$1 directories.list | while read line; do echo $line; done
