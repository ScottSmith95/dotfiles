#!/bin/sh

# macOS Guest (non-root) user.

# Variables.
Username='ssmith95'
ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #http://stackoverflow.com/a/246128/1867887
Style='\033[0;36m'
Reset='\033[0m' # No Color

printf "\n${Style}/////////////////////////\n"
printf "Welcome! \n\n"
printf "Kicking things off by installing Homebrew. \n"
printf "/////////////////////////${Reset}\n\n"

mkdir -p ~/usr
chflags hidden ~/usr
echo "PATH=/Users/${Username}/usr/local/bin:$PATH" > ~/.bash_profile

# chmod +x install.rb
# ./install.rb

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew upgrade

# Node
printf "\n${Style}/////////////////////////\n"
printf "Installing Node Things. \n"
printf "/////////////////////////${Reset}\n\n"
brew tap homebrew/versions
brew install node6-lts
npm install -g npm # Update npm.
npm install -g npm-check gulp-cli

# Files to move over:
# 	~/Documents/* (not synced/aliased crap)
# 	~/Pictures/* (sans iCloud Photo Library)
# 	~/Movies/*
# 	~/Library/Application Support/Adobe/Lightroom/Develop Presets/User Presets/*
#   ~/Library/Application Support/com.bohemiancoding.sketch3/Plugins/*
#   ~/Library/Fonts/*
#   ~/.ssh/id_rsa; ~/.ssh/id_rsa.pub

printf "\n${Style}/////////////////////////\n"
printf "Installing Apps from Homebrew. \n\n"
printf "/////////////////////////${Reset}\n\n"
cd $ScriptDir
brew tap Homebrew/bundle
# brew install mas
brew bundle

# mas signin --dialog InventScott@icloud.com

brew cask cleanup
brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*

# Atom
# apm install less-than-slash
# apm install aesthetic-ui

# Hyper
# 'hyperterm-close-on-left',
# 'hypercwd',
# 'hyperline',
# 'hyperterm-tabs'

printf "\n${Style}/////////////////////////\n"
printf "Tweaking a couple settings... \n"
printf "/////////////////////////${Reset}\n\n"

# Ref: [https://github.com/mathiasbynens/dotfiles/blob/master/.macos]
# Turn on tap-to-click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 # login screen too :)
# Stop auto-rearranging Mission Control
defaults write com.apple.dock mru-spaces -bool false
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# Set Safari’s home page to the favourites page
defaults write com.apple.Safari HomePage -string "" # Not sure if the next one works
defaults write com.apple.Safari HomePage -string "favorites://"
# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Sort contacts by first name
defaults write com.apple.AddressBook ABNameSortingFormat -string "sortingFirstName sortingLastName"

# The following preferences overwrite UW-IT's preference settings, not defaults.
# Enable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
# Don't show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool false
# Reset tracking speed
defaults delete -g com.apple.trackpad.scaling
# Speed up Mission Control animations
defaults delete com.apple.dock expose-animation-duration

# Set git info
git config --global user.name "Scott Smith"
git config --global user.email mail@ScottHSmith.com
export EDITOR='nano';

for app in "Finder" "Safari" "Dock"; do
  killall "${app}" &> /dev/null
done
printf "\n${Style}Settings updated. Some changes require a logout/restart to take effect.${Reset}\n"

printf "\n${Style}/////////////////////////\n"
printf "OK, that's all for now. \n"
printf "/////////////////////////${Reset}\n\n"
