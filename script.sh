#!/bin/bash

function Step(){
  Spacer="\n===================\n"
  printf "$Spacer$1$Spacer"
}

URL=https://setup.rbxcdn.com/mac/RobloxStudio.dmg
temp=/tmp/`openssl rand -base64 10 | tr -dc '[:alnum:]'`.dmg

#================#
Step "Downloading..."
echo "URL is $URL"
curl -# -L -o $temp $URL
echo "Temporary file is $temp"

#================#
Step "Mounting image..."
# Mount the package and save disk and volume locations
app_image=$(hdiutil attach $temp | tail -n 1 | tr -s "[:blank:]" "\n")

# Get disk of the mounted package e.g. /dev/disk4s1
app_disk=$(echo $app_image | tr -s " " "\n" | head -n 1)

# Get the Volume of the package e.g. /Volumes/RobloxStudioInstaller
if [ $(echo $app_image | tr -s " " "\n" | wc -l ) -gt 3 ]; then
  # If the same disk is mounted multiple times, an additional number will be returned, we don't want that
  app_volume=$(echo $app_image | tr -s " " "\n" | tail -n 2 | head -n 1)
else
  # If this is the first mount of the image, just get the volume
  app_volume=$(echo $app_image | tr -s " " "\n" | tail -n 1)
fi

echo "App Image:  $app_image"
echo "App Disk:   $app_disk"
echo "App Volume: $app_volume"

#================#
Step "Installing..."
app=`find $app_volume/. -name *.app -maxdepth 1 -type d -print0`
echo "Copying the app from $app to /Applications/RobloxStudioInstaller.app"
cp -r $app /Applications

echo "Running installer"
open -W /Applications/RobloxStudioInstaller.app

echo "Stopping Roblox Studio"
pkill -x RobloxStudio

#================#
Step "Cleaning up..."
echo "Un-mounting the image"
hdiutil detach $app_disk

echo "Removing a temporary file"
rm $temp

echo "Removing the installer"
rm -rf /Applications/RobloxStudioInstaller.app

#================#
Step "Done!"
