source $stdenv/setup
#. $makeWrapper

ensureDir "$(dirname $out)"
ensureDir "$(dirname $out/sbin/mingetty)"

cat > $out/sbin/mingetty << END
#! $SHELL -e
exec $mingetty/sbin/mingetty --loginprog=$shadowutils/bin/login "\$@"
END

chmod +x $out/sbin/mingetty
