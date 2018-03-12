export DISPLAY=":@display@"
@xdummy@/bin/xdummy "$DISPLAY" &
while ! @xrandr@/bin/xrandr -q; do
  sleep 1;
done

@xrandr@/bin/xrandr --output default --mode "@geometry@"
@xrandr@/bin/xrandr --dpi "@dpi@"
echo Xft.dpi:"@dpi@" | @xrdb@/bin/xrdb -
