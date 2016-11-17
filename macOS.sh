#!/bin/sh

# macOS

# Variables.
Username='Scott'
ScriptDir='/Users/Scott/Documents/Personal/Startup\ Scripts'
Style='\033[0;36m'
Reset='\033[0m' # No Color

printf "\n${Style}/////////////////////////\n"
printf "Welcome! \n\n"
printf "Kicking things off by installing Homebrew. \n"
printf "/////////////////////////${Reset}\n\n"

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade

# Node
printf "\n${Style}/////////////////////////\n"
printf "Installing Node Things. \n"
printf "/////////////////////////${Reset}\n\n"
brew tap homebrew/versions
brew install node6-lts
npm install --depth -1 --quiet -g npm # Update npm.
npm install --depth -1 --quiet -g npm-check gulp-cli

# Python
sudo easy_install -q pip

# Files to move over:
  # ~/Documents/* (not synced/aliased crap)
  # ~/Pictures/* (sans iCloud Photo Library)
  # ~/Movies/*
  # ~/.ssh/id_rsa; ~/.ssh/id_rsa.pub
  # ~/Library/Fonts/*
  # ~/Library/Application Support/Adobe/Lightroom/Develop Presets/User Presets/*
  # ~/Library/Application Support/com.bohemiancoding.sketch3/Plugins/*

printf "\n${Style}/////////////////////////\n"
printf "Installing Apps from Homebrew and MAS. \n\n"
printf "Get ready to type in Apple ID password. \n"
printf "/////////////////////////${Reset}\n\n"
cd $ScriptDir
brew install mas
mas signin --dialog InventScott@icloud.com

brew tap Homebrew/bundle
brew bundle

brew cask cleanup
brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*

# Atom
# apm install less-than-slash aesthetic-ui

# Hyper
# 'hyperterm-close-on-left',
# 'hypercwd',
# 'hyperline',
# 'hyperterm-tabs'

printf "\n${Style}/////////////////////////\n"
printf "Adding Startup Items... \n"
printf "/////////////////////////${Reset}\n\n"
# Ref: https://hamstergene.github.io/post/editing-osx-login-items-cmdline/
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Sip.app", name:"Sip"}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/KeepingYouAwake.app", name:"KeepingYouAwake"}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Quitter.app", name:"Quitter"}'

printf "\n${Style}/////////////////////////\n"
printf "Tweaking a couple settings... \n"
printf "/////////////////////////${Reset}\n\n"

# Ref: [https://github.com/mathiasbynens/dotfiles/blob/master/.macos]
# Turn on tap-to-click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 # login screen too :)
# Stop auto-rearranging Mission Control.
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
# Set Safari’s home page to the favourites page.
defaults write com.apple.Safari HomePage -string "" # Not sure if the next one works.
defaults write com.apple.Safari HomePage -string "favorites://"
# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Hide the horrendous Adobe folder after LR opens.
chflags hidden ~/Documents/Adobe

# Set git info
git config --global user.name "Scott Smith"
git config --global user.email mail@ScottHSmith.com
export EDITOR='nano';

# SSH Key Permissions
chmod 400 ~/.ssh/id_rsa

for app in "Finder" "Safari" "Dock"; do
  killall "${app}" &> /dev/null
done
printf "\n${Style}Settings updated. Some changes require a logout/restart to take effect.${Reset}\n"

printf "\n${Style}/////////////////////////\n"
printf "OK, that's all for now. \n"
printf "/////////////////////////${Reset}\n\n"
