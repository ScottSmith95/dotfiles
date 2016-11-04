#!/bin/sh

# Run this file to download and run environment setup.

Style='\033[0;36m'
Reset='\033[0m' # No Color

printf "\n${Style}/////////////////////////\n"
printf "Downloading files... \n"

GIST_PATH=https://github.com/ScottSmith95/dotfiles/archive/guest.zip

cd ~/Desktop
mkdir -p setup
cd setup
curl -fsSL $GIST_PATH -o setup.zip
unzip -oq setup.zip
mv -qv dotfiles-guest/* ./ &>/dev/null
rm -rf setup.zip dotfiles-guest

printf "\nDone. \n"
printf "Attempting to run script. \n"

chmod +x macOS.sh

printf "Success! \n"
printf "/////////////////////////${Reset}\n"

./macOS.sh
