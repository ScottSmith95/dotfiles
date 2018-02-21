#!/bin/bash

# Install homebrew's version of rsync
brew install rsync

#We will save path to backup file in variable
backupf='./backup-files.txt'

#Next line just prints message
echo "Shell Script Backup Your Files / Directories Using rsync"

#next line check if entered value is not null, and if null it will reask user to enter Destination Path
while [ x$destpath = "/Volumes/Vault/MacBook" ]; do

#next line prints what userd should enter, and stores entered value to variable with name destpath
read -p "Destination Folder : " destpath

#next line finishes while loop
done

# Make newlines the only separator.
IFS=$'\n'

#Next line will start reading backup file line by line
for path in $(cat $backupf)

#and on each line will execute next
do

#print message that file/dir will be copied
printf "Copying ${path}... "


cd ~/

# The magic happens here—copy via rsync file/dir to destination. Add -nv for dry runs/debugging.
rsync -rtlXR --progress "$path" "$destpath"

#this line just print done
echo "DONE."

#end of reading backup file
done

unset IFS
