source $stdenv/setup

ensureDir "$(dirname $out/dev/MAKEDEV)"
ensureDir "$(dirname $out/sbin/MAKEDEV)"

cat > $out/dev/MAKEDEV << END
#! $SHELL -e
exec $MAKEDEV/dev/MAKEDEV -c $MAKEDEV/etc/makedev.d/ "\$@"
END

chmod +x $out/dev/MAKEDEV
ln -s $out/dev/MAKEDEV $out/sbin/MAKEDEV
