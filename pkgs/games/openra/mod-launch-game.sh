#!/bin/sh
show_error() {
  if command -v zenity > /dev/null; then
    zenity --no-wrap --no-markup --error --title "OpenRA - @title@" --text "$1" 2>/dev/null
  else
    printf "$1\n" >&2
  fi
  exit 1
}

cd "@out@/lib/openra-@name@"

# Check for missing assets
assetsError='@assetsError@'
if [ -n "$assetsError" -a ! -d "$HOME/.openra/Content/@name@" ]; then
  show_error "$assetsError"
fi

# Run the game
mono --debug OpenRA.Game.exe Game.Mod=@name@ Engine.LaunchPath="@out@/bin/openra-@name@" Engine.ModSearchPaths="@out@/lib/openra-@name@/mods" "$@"

# Show a crash dialog if something went wrong
if [ $? -ne 0 -a $? -ne 1 ]; then
  show_error "OpenRA - @title@ has encountered a fatal error.\nPlease refer to the crash logs for more information.\n\nLog files are located in ~/.openra/Logs"
fi
