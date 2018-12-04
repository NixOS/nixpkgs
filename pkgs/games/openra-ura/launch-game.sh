#!/bin/sh
cd "@out@/lib/openra-ura"

# Run the game
mono --debug OpenRA.Game.exe Game.Mod=ura Engine.LaunchPath="@out@/bin/openra-ura" Engine.ModSearchPaths="@out@/lib/openra-ura/mods" "$@"

# Show a crash dialog if something went wrong
if [ $? != 0 ] && [ $? != 1 ]; then
  error_message="OpenRA Red Alert Unplugged has encountered a fatal error.\nPlease refer to the crash logs for more information.\n\nLog files are located in ~/.openra/Logs\n"
  if command -v zenity > /dev/null; then
    zenity --no-wrap --error --title "OpenRA Red Alert Unplugged" --text "$error_message" 2>/dev/null
  else
    printf "${error_message}\n" >&2
  fi
  exit 1
fi
