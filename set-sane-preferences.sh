#!/bin/bash

# Remember where this script is
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/CONFIG

# Initialize bootstrap script functions and helpers
source $DIR/helpers/bash_helpers.sh

# Attempt at never requiring sudo password...
sudo_forever

echo ""
echo "Let's set some sane macOS sane defaults!"
echo ""

# Install Homebrew
which brew &> /dev/null
if [[ $? -ne 0 ]]; then
    if ask "Install Homebrew?" Y; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
else
    echo "Homebrew is already installed. Skipping."
fi

which brew &> /dev/null; HOMEBREW_INSTALLED=$?

if [[ $HOMEBREW_INSTALLED -eq 0 ]]; then
    echo ""
    echo "Homebrew packages: $HOMEBREW_PACKAGES"
    if ask "Install Homebrew packages listed above?" Y; then
        brew install -q $HOMEBREW_PACKAGES
    fi

    echo ""
    echo "Homebrew Cask packages: $HOMEBREW_CASKS"
    if ask "Install Cask packages listed above?" Y; then
        brew install -q $HOMEBREW_CASKS
    fi


    echo ""
    echo "Font list: $HOMEBREW_FONT_LIST"
    if ask "Install fonts listed above from Homebrew?" Y; then
        tap "homebrew/cask-fonts"
        HOMEBREW_FONT_LIST=$(echo "$HOMEBREW_FONT_LIST" | sed 's/[^ ]* */font-&/g')
        brew install -q --cask $HOMEBREW_FONT_LIST
    fi

    echo ""
    echo "Homebrew QuickLook packages: $HOMEBREW_QUICKLOOK"
    if ask "Install QuickLook packages listed above?" Y; then
        brew install -q $HOMEBREW_QUICKLOOK
    fi
fi

# Wipe dock clean
if ask "Remove all apps from Dock?" Y; then
    defaults write com.apple.dock persistent-apps -array
    killall Dock
fi

if ask "Install French Canadian keyboard?" Y; then
    git clone https://github.com/cmer/cf-keylayout.git /tmp/keyb > /dev/null
    /tmp/keyb/install > /dev/null
fi

echo "Expanding the save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "Save to disk, rather than iCloud, by default."
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "Removing duplicates in the 'Open With' menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

echo "Disable the sudden motion sensor? (it's not useful for SSDs/current MacBooks)."
sudo pmset -a sms 0

echo "Increasing sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Disabling press-and-hold for special keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Setting a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0

echo "Setting trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

echo "Turn off keyboard illumination when computer is not used for 5 minutes"

echo "Show status bar in Finder by default."
defaults write com.apple.finder ShowStatusBar -bool true

echo "Avoid creation of .DS_Store files on network volumes."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "Disable disk image verification."
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo "Allowing text selection in Quick Look/Preview in Finder by default."
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "Privacy: Don't send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo "Hiding Safari's sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo "Disabling Safari's thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo "Enabling Safari's debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo "Making Safari's search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo "Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "Using the system-native print preview dialog in Chrome"
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

echo "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "Prevent Time Machine from prompting to use new hard drives as backup volume."
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "Enable tap to click (Trackpad) for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Enable the automatic AppStore update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo "Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo "Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

echo "Turn on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true


echo ""
echo "Done."
echo ""
