#!@bash@/bin/bash -e

# Always run steamcmd in the user's Steam root.
STEAMROOT=@steamRoot@

# Create a facsimile Steam root if it doesn't exist.
if [ ! -e "$STEAMROOT" ]; then
  mkdir -p "$STEAMROOT"/{appcache,config,logs,Steamapps/common}
  mkdir -p ~/.steam
  ln -sf "$STEAMROOT" ~/.steam/root
  ln -sf "$STEAMROOT" ~/.steam/steam
fi

# Copy the system steamcmd install to the Steam root. If we don't do
# this, steamcmd assumes the path to `steamcmd` is the Steam root.
# Note that symlinks don't work here.
if [ ! -e "$STEAMROOT/steamcmd.sh" ]; then
  mkdir -p "$STEAMROOT/linux32"
  # steamcmd.sh will replace these on first use
  cp @out@/share/steamcmd/steamcmd.sh "$STEAMROOT/."
  cp @out@/share/steamcmd/linux32/* "$STEAMROOT/linux32/."
fi

@steamRun@/bin/steam-run "$STEAMROOT/steamcmd.sh" "$@"
