#!@shell@

# Create user directory if it doesn't exist
if [ ! -d "$HOME/.nwn/" ]; then
    mkdir "$HOME/.nwn/"
fi

cd @out@/nwn

export SDL_MOUSE_RELATIVE=0
export SDL_VIDEO_X11_DGAMOUSE=0

# Hardware Mouse Cursor
export XCURSOR_PATH=@out@/nwn
export XCURSOR_THEME=nwmouse

# Add Miles Sound Codec to Library Path
export LD_LIBRARY_PATH="./miles:$LD_LIBRARY_PATH"

# Enable video scaling and optimizations
[ -z "$BINK_SCALE" ] && export BINK_SCALE=1
[ -z "$BINK_SMOOTH" ] && export BINK_SMOOTH=1

# Per-User Settings Support, Hardware Mouse Cursor Support, Linux Movies Support, Client Side Chat Logging Support
export LD_PRELOAD="./nwuser.so:./nwuser64.so:./nwmouse.so:./nwmovies.so:./nwlogger.so:$LD_PRELOAD"

# Run Neverwinter Nights
exec ./nwmain "$@"
