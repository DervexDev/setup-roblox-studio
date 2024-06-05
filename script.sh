#!/bin/bash

function Step(){
  Spacer="\n===================\n"
  printf "$Spacer$1$Spacer"
}

URL=https://setup.rbxcdn.com/mac/RobloxStudio.dmg
temp=/tmp/`openssl rand -base64 10 | tr -dc "[:alnum:]"`.dmg

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

echo "Running the installer"
open -W /Applications/RobloxStudioInstaller.app

if [ "$1" != "" ] && [ "$2" != "" ]; then
  echo "Logging in"

  osascript -e "
  tell application \"System Events\"
    repeat
	  	if process \"RobloxStudio\" exists then
	  		exit repeat
	  	end if

	  	delay 1
	  end repeat
	
	  delay 5

	  tell process \"RobloxStudio\"
	  	set frontmost to true
	  	perform action \"AXRaise\" of window 1
	  	set position of window 1 to {0, 0}

	  	delay 1

	  	click at {100, 210}
	  	keystroke \"$1\"

	  	click at {100, 260}
	  	keystroke \"$2\"

	  	click at {100, 310}
	  end tell
  end tell"

  if [ $3 != true ]; then
    sleep 7
    echo "Stopping Roblox Studio"
    pkill -x RobloxStudio
  fi
elif [ $3 != true ]; then
  echo "Stopping Roblox Studio"
  pkill -x RobloxStudio
fi

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
