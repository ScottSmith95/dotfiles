#!/bin/sh

# macOS

# Variables.
Username='scott'
ScriptDir="/Users/scott/Documents/Personal/Startup\ Scripts/"
Style='\033[0;36m'
Reset='\033[0m' # No Color

# Command Line Tools
printf "\n${Style}/////////////////////////\n"
printf "Welcome! \n\n"
printf "Kicking things off by installing Command Line Tools. \n"
printf "/////////////////////////${Reset}\n\n"

xcode-select --install

printf "\n${Style}/////////////////////////\n"
printf "Nice! \n\n"
printf "Moving on to installing Homebrew. \n"
printf "/////////////////////////${Reset}\n\n"

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade

sudo chown -R $(whoami) /usr/local/share/man/man5 /usr/local/share/man/man7 /usr/local/share/man/man8
chmod u+w /usr/local/share/man/man5 /usr/local/share/man/man7 /usr/local/share/man/man8

# Node
printf "\n${Style}/////////////////////////\n"
printf "Installing Node Things. \n"
printf "/////////////////////////${Reset}\n\n"
brew install n
sudo n lts
sudo npm update --quiet -g npm
sudo npm install --quiet -g npm-check gulp-cli trash-cli now

# Python
brew install python
# set Python 3 as the default
export PATH="$(brew --prefix python)/libexec/bin:$PATH"
pip3 install virtualenv

# Files to move over:
  # ~/Parallels/
  # ~/Pictures/* (sans iCloud Photo, Lightroom Library)
  # ~/Movies/*
  # ~/Sites/*.code-workspace
  # ~/.ssh/id_rsa; ~/.ssh/id_rsa.pub
  # ~/Library/Fonts/*
  # ~/Library/Application Support/com.bohemiancoding.sketch3/Plugins/*
  # ~/Library/Application Support/Code/User/settings.json
  # ~/Library/Application Support/Coda 2/Modes/*
  # ~/Library/Application Support/Coda 2/Plug-ins/*
  # ~/Library/Preferences/Adobe InDesign/Version 14.0/en_GB/Workspaces/Scott.xml

printf "\n${Style}/////////////////////////\n"
printf "Installing Apps from Homebrew and MAS. \n\n"
printf "Get ready to type in Apple ID password. \n"
printf "/////////////////////////${Reset}\n\n"
cd $ScriptDir
brew install mas

printf "\n${Style}/////////////////////////\n"
printf "Type in your Apple ID below for App Store authentication. \n${Reset}"
read AppleID
printf "${Style}/////////////////////////${Reset}\n\n"
mas signin --dialog $AppleID

brew tap Homebrew/bundle
brew bundle

brew cleanup
brew cleanup --force
rm -rf /Library/Caches/Homebrew/*

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
# Ask websites not to track me
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
# Show status bar
defaults write com.apple.Safari ShowStatusBar -bool true
# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Sort contacts by first name
defaults write com.apple.AddressBook ABNameSortingFormat -string "sortingFirstName sortingLastName"
# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
# Hide the horrendous Adobe folder after LR opens
chflags hidden ~/Documents/Adobe

# Visual Studio Code Extensions
code --install-extension formulahendry.auto-close-tag
code --install-extension dbaeumer.vscode-eslint
code --install-extension eg2.vscode-npm-script
code --install-extension esbenp.prettier-vscode
code --install-extension kelvin.vscode-sshfs
code --install-extension esbenp.csstools.postcss

# Set git info
git config --global user.name "Scott Smith"
git config --global user.email mail@ScottHSmith.com
git config --global core.editor "nano"

printf "\n${Style}/////////////////////////\n"
printf "Attempting automatic key import. \n" 
printf "Directions available here: https://github.com/pstadler/keybase-gpg-github \n" 
printf "/////////////////////////${Reset}\n\n"
touch ~/.profile && echo GPG_TTY=$(tty) >> ~/.profile && echo export GPG_TTY >> ~/.profile
keybase pgp export -q E9934D940E9347EE | gpg --import
keybase pgp export -q E9934D940E9347EE --secret | gpg --import --allow-secret-key-import
gpg --list-secret-keys --keyid-format LONG

git config --global user.signingkey E9934D940E9347EE
git config --global commit.gpgsign true

# SSH Key Permissions
chmod 400 ~/.ssh/id_rsa

for app in "Finder" "Safari" "Dock"; do
  killall "${app}" &> /dev/null
done
printf "\n${Style}Settings updated. Some changes require a logout/restart to take effect.${Reset}\n"

printf "\n${Style}/////////////////////////\n"
printf "OK, that's all for now. \n"
printf "/////////////////////////${Reset}\n\n"
