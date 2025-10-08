#!/usr/bin/env bash
# https://privacy.sexy — v0.13.8 — Sat, 13 Sep 2025 21:37:19 GMT
if [ "$EUID" -ne 0 ]; then
    script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
    sudo "$script_path" || (
        echo 'Administrator privileges are required.'
        exit 1
    )
    exit 0
fi


# ----------------------------------------------------------
# ----------------Disable Firefox telemetry-----------------
# ----------------------------------------------------------
echo '--- Disable Firefox telemetry'
# Enable Firefox policies so the telemetry can be configured.
sudo defaults write /Library/Preferences/org.mozilla.firefox EnterprisePoliciesEnabled -bool TRUE
# Disable sending usage data
sudo defaults write /Library/Preferences/org.mozilla.firefox DisableTelemetry -bool TRUE
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------Disable Microsoft Office telemetry------------
# ----------------------------------------------------------
echo '--- Disable Microsoft Office telemetry'
defaults write com.microsoft.office DiagnosticDataTypePreference -string ZeroDiagnosticData
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------Disable Homebrew user behavior analytics---------
# ----------------------------------------------------------
echo '--- Disable Homebrew user behavior analytics'
command='export HOMEBREW_NO_ANALYTICS=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"
do
    touch "$profile_file"
    if ! grep -q "$command" "${profile_file}"; then
        echo "$command" >> "$profile_file"
        echo "[$profile_file] Configured"
    else
        echo "[$profile_file] No need for any action, already configured"
    fi
done
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Disable participation in Siri data collection-------
# ----------------------------------------------------------
echo '--- Disable participation in Siri data collection'
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Disable online spell correction--------------
# ----------------------------------------------------------
echo '--- Disable online spell correction'
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Disable remote Apple events----------------
# ----------------------------------------------------------
echo '--- Disable remote Apple events'
sudo systemsetup -setremoteappleevents off
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable automatic storage of documents in iCloud Drive--
# ----------------------------------------------------------
echo '--- Disable automatic storage of documents in iCloud Drive'
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# ----------------------------------------------------------


# Disable personalized advertisements and identifier tracking
echo '--- Disable personalized advertisements and identifier tracking'
defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
defaults write com.apple.AdLib forceLimitAdTracking -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable automatic incoming connections for signed apps--
# ----------------------------------------------------------
echo '--- Disable automatic incoming connections for signed apps'
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false
# ----------------------------------------------------------


# Disable automatic incoming connections for downloaded signed apps
echo '--- Disable automatic incoming connections for downloaded signed apps'
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Disable guest account login----------------
# ----------------------------------------------------------
echo '--- Disable guest account login'
sudo defaults write '/Library/Preferences/com.apple.loginwindow' 'GuestEnabled' -bool NO
if ! command -v 'sysadminctl' &> /dev/null; then
    echo 'Skipping because "sysadminctl" is not found.'
else
    sudo sysadminctl -guestAccount off
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Disable guest file sharing over SMB------------
# ----------------------------------------------------------
echo '--- Disable guest file sharing over SMB'
sudo defaults write '/Library/Preferences/SystemConfiguration/com.apple.smb.server' 'AllowGuestAccess' -bool NO
if ! command -v 'sysadminctl' &> /dev/null; then
    echo 'Skipping because "sysadminctl" is not found.'
else
    sudo sysadminctl -smbGuestAccess off
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Disable guest file sharing over AFP------------
# ----------------------------------------------------------
echo '--- Disable guest file sharing over AFP'
sudo defaults write '/Library/Preferences/com.apple.AppleFileServer' 'guestAccess' -bool NO
if ! command -v 'sysadminctl' &> /dev/null; then
    echo 'Skipping because "sysadminctl" is not found.'
else
    sudo sysadminctl -afpGuestAccess off
fi
sudo killall -HUP AppleFileServer
# ----------------------------------------------------------


# Enable session lock five seconds after screen saver initiation
echo '--- Enable session lock five seconds after screen saver initiation'
sudo defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5
# ----------------------------------------------------------


# Enable password requirement for waking from sleep or screen saver
echo '--- Enable password requirement for waking from sleep or screen saver'
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------------Clear DNS cache----------------------
# ----------------------------------------------------------
echo '--- Clear DNS cache'
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear diagnostic logs-------------------
# ----------------------------------------------------------
echo '--- Clear diagnostic logs'
# Clear directory contents: "/private/var/db/diagnostics"
glob_pattern="/private/var/db/diagnostics/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear diagnostic log details---------------
# ----------------------------------------------------------
echo '--- Clear diagnostic log details'
# Clear directory contents: "/private/var/db/uuidtext"
glob_pattern="/private/var/db/uuidtext/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear Apple System Logs (ASL)---------------
# ----------------------------------------------------------
echo '--- Clear Apple System Logs (ASL)'
# Clear directory contents: "/private/var/log/asl"
glob_pattern="/private/var/log/asl/*"
sudo rm -rfv $glob_pattern
# Delete files matching pattern: "/private/var/log/asl.log"
glob_pattern="/private/var/log/asl.log"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/asl.db"
glob_pattern="/private/var/log/asl.db"
sudo rm -fv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------------Clear installation logs------------------
# ----------------------------------------------------------
echo '--- Clear installation logs'
# Delete files matching pattern: "/private/var/log/install.log"
glob_pattern="/private/var/log/install.log"
sudo rm -fv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear all system logs-------------------
# ----------------------------------------------------------
echo '--- Clear all system logs'
# Clear directory contents: "/private/var/log"
glob_pattern="/private/var/log/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear system application logs---------------
# ----------------------------------------------------------
echo '--- Clear system application logs'
# Clear directory contents: "/Library/Logs"
glob_pattern="/Library/Logs/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear user application logs----------------
# ----------------------------------------------------------
echo '--- Clear user application logs'
# Clear directory contents: "$HOME/Library/Logs"
glob_pattern="$HOME/Library/Logs/*"
 rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear Mail app logs--------------------
# ----------------------------------------------------------
echo '--- Clear Mail app logs'
# Clear directory contents: "$HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail"
glob_pattern="$HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*"
 rm -rfv $glob_pattern
# ----------------------------------------------------------


# Clear user activity audit logs (login, logout, authentication, etc.)
echo '--- Clear user activity audit logs (login, logout, authentication, etc.)'
# Clear directory contents: "/private/var/audit"
glob_pattern="/private/var/audit/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear system maintenance logs---------------
# ----------------------------------------------------------
echo '--- Clear system maintenance logs'
# Delete files matching pattern: "/private/var/log/daily.out"
glob_pattern="/private/var/log/daily.out"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/weekly.out"
glob_pattern="/private/var/log/weekly.out"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/monthly.out"
glob_pattern="/private/var/log/monthly.out"
sudo rm -fv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear app installation logs----------------
# ----------------------------------------------------------
echo '--- Clear app installation logs'
# Clear directory contents: "/private/var/db/receipts"
glob_pattern="/private/var/db/receipts/*"
sudo rm -rfv $glob_pattern
# Delete files matching pattern: "/Library/Receipts/InstallHistory.plist"
glob_pattern="/Library/Receipts/InstallHistory.plist"
 rm -fv $glob_pattern
# ----------------------------------------------------------


echo 'Your privacy and security is now hardened 🎉💪'
echo 'Press any key to exit.'
read -n 1 -s
