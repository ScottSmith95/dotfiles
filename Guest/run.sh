#!/bin/sh

# Run this file to download and run environment setup.

GIST_PATH=https://gist.github.com/ScottSmith95/87d16e272255b9528f892bce265dfd90/archive/64cfe99c8191848a5f85a03983da3223864b1c68.zip

cd ~/Desktop
curl -fsSL $GIST_PATH -o setup.zip
unzip setup.zip
# rm setup.zip
# cd setup
# echo "I'd run that."
# sh -c macOS.sh
