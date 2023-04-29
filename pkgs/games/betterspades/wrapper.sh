#!/bin/sh
dir=$(mktemp -d)
cleanup(){
  rm -rf "$dir"
}
trap cleanup EXIT
pdir=$(dirname $(dirname $(realpath $0)))
for i in fonts kv6 png wav; do
  ln -s "$pdir/share/data/$i" "$dir/$i"
done
if [ -n "$XDG_CONFIG_HOME" ]; then
  cfgdir="$XDG_CONFIG_HOME"
else
  cfgdir=~/.config
fi
if [ -f "$cfgdir/betterspades/config.ini" ]; then
  ln -s "$cfgdir/betterspades/config.ini" "$dir/config.ini"
else
  install -D "$pdir/share/data/config.ini" "$cfgdir/betterspades/config.ini"
  ln -s "$cfgdir/betterspades/config.ini" "$dir/config.ini"
fi
mkdir -p "$cfgdir/betterspades/screenshots"
ln -s "$cfgdir/betterspades/screenshots" "$dir/screenshots"
if [ -n "$XDG_CACHE_HOME" ];then
  cachedir="$XDG_CACHE_HOME"
else
  cachedir=~/.cache
fi
mkdir -p "$cachedir/betterspades/cache" "$cachedir/betterspades/logs" "$cachedir/betterspades/vxl"
ln -s "$cachedir/betterspades/cache" "$dir/cache"
ln -s "$cachedir/betterspades/logs" "$dir/logs"
ln -s "$cachedir/betterspades/vxl" "$dir/vxl"
cd "$dir"
"$pdir"/bin/.betterspades-wrapped $@
cleanup
