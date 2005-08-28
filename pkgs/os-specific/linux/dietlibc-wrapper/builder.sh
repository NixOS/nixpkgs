. $stdenv/setup

#export NIX_GLIBC_FLAGS_SET=1

ensureDir "$(dirname $out/bin/diet)"

cat > $out/bin/gcc << END
#! $SHELL -e
exec $dietlibc/bin/diet $gcc/bin/gcc "\$@"
END

chmod +x $out/bin/gcc

ln -s $out/bin/gcc $out/bin/cc
